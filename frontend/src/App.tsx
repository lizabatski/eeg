import { useEffect, useMemo, useRef, useState } from "react";
import uPlot, { type AlignedData } from "uplot";
import "uplot/dist/uPlot.min.css";

import {
  parseServerMessage,
  type MetadataMessage,
  type SourceMode,
} from "./protocol";

const WINDOW_SECONDS = 10;
const DISCONNECT_AFTER_MS = 2_000;
const TRACE_COLORS = [
  "#38bdf8",
  "#a78bfa",
  "#34d399",
  "#fbbf24",
  "#fb7185",
  "#22d3ee",
  "#c084fc",
  "#a3e635",
];

type ViewerStatus =
  | "connecting"
  | "streaming"
  | "disconnected"
  | "finished"
  | "error";

type Buffers = {
  times: number[];
  channels: Array<Array<number | null>>;
};

function ChannelChart({
  name,
  color,
  times,
  values,
}: {
  name: string;
  color: string;
  times: number[];
  values: Array<number | null>;
}) {
  const containerRef = useRef<HTMLDivElement>(null);
  const chartRef = useRef<uPlot | null>(null);

  useEffect(() => {
    const container = containerRef.current;
    if (!container) return;
    const chart = new uPlot(
      {
        width: Math.max(320, container.clientWidth),
        height: 128,
        legend: { show: false },
        cursor: { show: true, drag: { x: false, y: false } },
        scales: { x: { time: false }, y: { auto: true } },
        axes: [
          {
            stroke: "#718096",
            grid: { stroke: "#1e293b", width: 1 },
            values: (_plot, ticks) => ticks.map((tick) => `${tick.toFixed(1)}s`),
          },
          {
            stroke: "#718096",
            grid: { stroke: "#1e293b", width: 1 },
            size: 58,
            values: (_plot, ticks) => ticks.map((tick) => tick.toFixed(0)),
          },
        ],
        series: [{}, { label: name, stroke: color, width: 1 }],
      },
      [[], []],
      container,
    );
    chartRef.current = chart;
    const observer = new ResizeObserver(([entry]) => {
      chart.setSize({
        width: Math.max(320, Math.floor(entry.contentRect.width)),
        height: 128,
      });
    });
    observer.observe(container);
    return () => {
      observer.disconnect();
      chart.destroy();
      chartRef.current = null;
    };
  }, [color, name]);

  useEffect(() => {
    chartRef.current?.setData([times, values] as AlignedData);
  }, [times, values]);

  return (
    <article className="channel-card">
      <div className="channel-label">
        <span className="channel-dot" style={{ backgroundColor: color }} />
        {name}
        <span>µV</span>
      </div>
      <div ref={containerRef} className="chart" />
    </article>
  );
}

export default function App() {
  const [selectedSource, setSelectedSource] = useState<SourceMode>("replay");
  const [status, setStatus] = useState<ViewerStatus>("connecting");
  const [metadata, setMetadata] = useState<MetadataMessage | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [revision, setRevision] = useState(0);
  const buffersRef = useRef<Buffers>({ times: [], channels: [] });
  const metadataRef = useRef<MetadataMessage | null>(null);
  const lastMessageAtRef = useRef(Date.now());
  const nextSequenceRef = useRef(0);
  const timestampOriginRef = useRef<number | null>(null);
  const finishedRef = useRef(false);

  useEffect(() => {
    const websocketUrl = new URL(
      import.meta.env.VITE_EEG_WS_URL ?? "ws://127.0.0.1:8765",
    );
    websocketUrl.searchParams.set("source", selectedSource);
    const socket = new WebSocket(websocketUrl);
    let active = true;
    finishedRef.current = false;
    metadataRef.current = null;
    timestampOriginRef.current = null;
    nextSequenceRef.current = 0;
    lastMessageAtRef.current = Date.now();
    buffersRef.current = { times: [], channels: [] };
    setMetadata(null);
    setError(null);
    setStatus("connecting");
    setRevision((value) => value + 1);

    socket.onmessage = (event) => {
      if (!active) return;
      try {
        if (typeof event.data !== "string") {
          throw new Error("Binary WebSocket messages are not supported");
        }
        const message = parseServerMessage(event.data);
        lastMessageAtRef.current = Date.now();
        if (message.type === "error") {
          setError(message.message);
          setStatus("error");
          socket.close(4001, "EEG source failed");
          return;
        }
        if (message.type === "metadata") {
          if (message.channel_names.length === 0 || message.sample_rate_hz <= 0) {
            throw new Error("Metadata contains no usable EEG channels");
          }
          const expectedSource =
            selectedSource === "replay" ? "recorded_replay" : "live_unicorn";
          if (message.source !== expectedSource) {
            throw new Error(`Backend returned unexpected source ${message.source}`);
          }
          metadataRef.current = message;
          setMetadata(message);
          setError(null);
          buffersRef.current = {
            times: [],
            channels: message.channel_names.map(() => []),
          };
          nextSequenceRef.current = 0;
          setStatus("streaming");
          setRevision((value) => value + 1);
          return;
        }
        if (message.type === "end") {
          finishedRef.current = true;
          setStatus("finished");
          socket.close(1000, "Stream finished");
          return;
        }

        const streamMetadata = metadataRef.current;
        if (!streamMetadata) {
          throw new Error("Samples arrived before metadata");
        }
        if (
          message.sample_rate_hz !== streamMetadata.sample_rate_hz ||
          message.values_uv.length !== streamMetadata.channel_names.length
        ) {
          throw new Error("Sample shape does not match stream metadata");
        }
        const sampleCount = message.values_uv[0]?.length ?? 0;
        if (
          sampleCount === 0 ||
          message.timestamps_s.length !== sampleCount ||
          message.values_uv.some((channel) => channel.length !== sampleCount)
        ) {
          throw new Error("Sample channels have inconsistent lengths");
        }
        if (
          message.timestamps_s.some(
            (timestamp, index) =>
              index > 0 && timestamp <= message.timestamps_s[index - 1],
          )
        ) {
          throw new Error("Sample timestamps are not strictly increasing");
        }

        const buffers = buffersRef.current;
        if (message.sequence < nextSequenceRef.current) {
          throw new Error("Sample sequence moved backwards");
        }
        if (timestampOriginRef.current === null) {
          timestampOriginRef.current = message.timestamps_s[0];
        }
        const normalizedTimes = message.timestamps_s.map(
          (timestamp) => timestamp - (timestampOriginRef.current ?? 0),
        );
        if (message.sequence > nextSequenceRef.current && buffers.times.length > 0) {
          buffers.times.push(normalizedTimes[0]);
          buffers.channels.forEach((channel) => channel.push(null));
        }
        nextSequenceRef.current = message.sequence + 1;
        buffers.times.push(...normalizedTimes);
        message.values_uv.forEach((channel, index) => {
          buffers.channels[index].push(...channel);
        });

        const latestTime = buffers.times.at(-1) ?? 0;
        const cutoff = latestTime - WINDOW_SECONDS;
        const trimCount = buffers.times.findIndex((time) => time >= cutoff);
        if (trimCount > 0) {
          buffers.times.splice(0, trimCount);
          buffers.channels.forEach((channel) => channel.splice(0, trimCount));
        }
        setStatus("streaming");
        setRevision((value) => value + 1);
      } catch (cause) {
        const message =
          cause instanceof Error ? cause.message : "Unknown stream error";
        setError(message);
        setStatus("error");
        socket.close(1002, message);
      }
    };

    socket.onerror = () => {
      if (active && !finishedRef.current) {
        setError("Could not connect to the EEG WebSocket server");
        setStatus("error");
      }
    };
    socket.onclose = () => {
      if (active && !finishedRef.current) {
        setStatus((current) => (current === "error" ? current : "disconnected"));
      }
    };

    const watchdog = window.setInterval(() => {
      if (
        socket.readyState === WebSocket.OPEN &&
        Date.now() - lastMessageAtRef.current > DISCONNECT_AFTER_MS
      ) {
        setStatus("disconnected");
        socket.close(4000, "No EEG samples received for two seconds");
      }
    }, 250);

    return () => {
      active = false;
      window.clearInterval(watchdog);
      socket.close();
    };
  }, [selectedSource]);

  const chartData = useMemo(() => {
    void revision;
    return {
      times: [...buffersRef.current.times],
      channels: buffersRef.current.channels.map((channel) => [...channel]),
    };
  }, [revision]);
  const recordingTime = chartData.times.at(-1) ?? 0;

  return (
    <main>
      <header>
        <div>
          <p className="eyebrow">NeuroLoop monitor</p>
          <h1>EEG waveform viewer</h1>
          <p className="subtitle">
            Raw scalp-voltage traces for engineering inspection (not an attention
            score or medical measurement.)
          </p>
        </div>
        <div className="header-status">
          <span className="source-badge">
            {selectedSource === "replay"
              ? "Recorded EEG replay"
              : "Live Unicorn EEG"}
          </span>
          <span className={`status status-${status}`}>{status}</span>
        </div>
      </header>

      <section className="source-control" aria-label="EEG data source">
        <div>
          <strong>Data source</strong>
          <span>Switching sources starts a new stream.</span>
        </div>
        <div className="source-options">
          <button
            type="button"
            className={selectedSource === "replay" ? "active" : ""}
            aria-pressed={selectedSource === "replay"}
            onClick={() => setSelectedSource("replay")}
          >
            Recorded replay
          </button>
          <button
            type="button"
            className={selectedSource === "unicorn" ? "active" : ""}
            aria-pressed={selectedSource === "unicorn"}
            onClick={() => setSelectedSource("unicorn")}
          >
            Live Unicorn
          </button>
        </div>
      </section>

      {error && <div className="error-banner">{error}</div>}

      <section className="summary" aria-label="Stream summary">
        <div>
          <span>Recording time</span>
          <strong>{recordingTime.toFixed(1)} s</strong>
        </div>
        <div>
          <span>Sample rate</span>
          <strong>{metadata ? `${metadata.sample_rate_hz} Hz` : "—"}</strong>
        </div>
        <div>
          <span>Channels</span>
          <strong>{metadata?.channel_names.length ?? "—"}</strong>
        </div>
        <div>
          <span>Visible window</span>
          <strong>{WINDOW_SECONDS} s</strong>
        </div>
      </section>

      <section className="waveforms" aria-label="EEG channels">
        {!metadata && status === "connecting" && (
          <div className="empty-state">
            Waiting for {selectedSource === "replay" ? "replay" : "Unicorn LSL"}{" "}
            metadata…
          </div>
        )}
        {metadata?.channel_names.map((name, index) => (
          <ChannelChart
            key={name}
            name={name}
            color={TRACE_COLORS[index % TRACE_COLORS.length]}
            times={chartData.times}
            values={chartData.channels[index] ?? []}
          />
        ))}
      </section>
    </main>
  );
}
