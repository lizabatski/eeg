export type SourceMode = "replay" | "unicorn";
export type SourceName = "recorded_replay" | "live_unicorn";

export type MetadataMessage = {
  type: "metadata";
  schema_version: 1;
  source: SourceName;
  channel_names: string[];
  sample_rate_hz: number;
  units: "microvolts";
  duration_seconds: number | null;
  timestamp_origin_s: number | null;
};

export type SamplesMessage = {
  type: "samples";
  sequence: number;
  timestamps_s: number[];
  sample_rate_hz: number;
  values_uv: number[][];
};

export type EndMessage = {
  type: "end";
  recording_time_s: number;
};

export type ErrorMessage = {
  type: "error";
  message: string;
};

export type ServerMessage =
  | MetadataMessage
  | SamplesMessage
  | EndMessage
  | ErrorMessage;

function isFiniteNumber(value: unknown): value is number {
  return typeof value === "number" && Number.isFinite(value);
}

export function parseServerMessage(raw: string): ServerMessage {
  const value: unknown = JSON.parse(raw);
  if (!value || typeof value !== "object" || !("type" in value)) {
    throw new Error("WebSocket message is not a typed object");
  }
  const message = value as Record<string, unknown>;
  if (message.type === "metadata") {
    if (
      message.schema_version !== 1 ||
      !["recorded_replay", "live_unicorn"].includes(String(message.source)) ||
      message.units !== "microvolts" ||
      !Array.isArray(message.channel_names) ||
      !message.channel_names.every((name) => typeof name === "string") ||
      !isFiniteNumber(message.sample_rate_hz) ||
      !(
        message.duration_seconds === null ||
        isFiniteNumber(message.duration_seconds)
      ) ||
      !(
        message.timestamp_origin_s === null ||
        isFiniteNumber(message.timestamp_origin_s)
      )
    ) {
      throw new Error("Invalid metadata message");
    }
    return message as MetadataMessage;
  }
  if (message.type === "samples") {
    if (
      !Number.isInteger(message.sequence) ||
      !isFiniteNumber(message.sample_rate_hz) ||
      !Array.isArray(message.timestamps_s) ||
      !message.timestamps_s.every((timestamp) => isFiniteNumber(timestamp)) ||
      !Array.isArray(message.values_uv) ||
      !message.values_uv.every(
        (channel) =>
          Array.isArray(channel) && channel.every((sample) => isFiniteNumber(sample)),
      )
    ) {
      throw new Error("Invalid sample message");
    }
    return message as SamplesMessage;
  }
  if (message.type === "end" && isFiniteNumber(message.recording_time_s)) {
    return message as EndMessage;
  }
  if (message.type === "error" && typeof message.message === "string") {
    return message as ErrorMessage;
  }
  throw new Error(`Unknown or invalid message type: ${String(message.type)}`);
}
