{
  "format": "brainstory_project",
  "version": 1,
  "datasets": [
    {
      "id": "1786473318163677",
      "label": "Ewing",
      "path": "/Users/jhd/Dropbox/Correspondence/Sample EEG data/2026-08-10/NOVA_ANT/Eyes open eyes closed/Ewing_Patrick_2026-08-10_13-07-25_EO-EC.cnt",
      "loaded": true,
      "sourceFilename": null,
      "sourceBytesBase64": null
    }
  ],
  "nodes": [
    {
      "id": "1786497948580428",
      "type": "Import",
      "x": 400.0,
      "y": 45.0,
      "params": {
        "selectedDatasetIds": [
          "1786473318163677"
        ],
        "sampleRateHz": 256.0,
        "datasetAliases": {
          "1786473318163677": "Ewing"
        },
        "storagePolicy": "prefer_disk",
        "window_sec": 10.0,
        "preview_bandpass": false,
        "preview_low": 1.0,
        "preview_high": 40.0,
        "marker_mode": "event",
        "interaction_mode": "edit",
        "interactive_template_matching_enabled": true,
        "marker_default_label": "new marker",
        "markers": [],
        "channel_colors": {},
        "marker_list_expanded": false,
        "marker_label_expanded": {},
        "artifact_exemplars_expanded": false,
        "artifact_candidates_expanded": true,
        "y_scale_uv": 100.0,
        "channel_spacing_factor": 1.0,
        "raw_show_data": true,
        "raw_show_markers": true,
        "raw_remove_dc": true,
        "right_panel_collapsed": false,
        "interactiveArtifactDetection": true,
        "artifactExemplars": [],
        "artifactCandidates": [],
        "artifactTemplates": [],
        "artifactThreshold": 0.78
      },
      "markerChange": {
        "rows": []
      },
      "datasetStates": {
        "1786473318163677": "done"
      }
    },
    {
      "id": "1786497961549492",
      "type": "Bandpass Filter",
      "x": 100.0,
      "y": 225.0,
      "params": {
        "low": 1.0,
        "high": 40.0,
        "steepness": 0.8,
        "notch": 60.0,
        "selectedDatasetIds": [
          "1786473318163677"
        ],
        "storagePolicy": "automatic",
        "window_sec": 10.0,
        "preview_bandpass": false,
        "preview_low": 1.0,
        "preview_high": 40.0,
        "marker_mode": "event",
        "interaction_mode": "view",
        "interactive_template_matching_enabled": false,
        "marker_default_label": "new marker",
        "markers": [],
        "channel_colors": {},
        "marker_list_expanded": false,
        "marker_label_expanded": {},
        "artifact_exemplars_expanded": true,
        "artifact_candidates_expanded": true,
        "y_scale_uv": 100.0,
        "channel_spacing_factor": 1.0,
        "raw_show_data": true,
        "raw_show_markers": true,
        "raw_remove_dc": true,
        "right_panel_collapsed": false
      },
      "markerChange": {
        "rows": []
      },
      "datasetStates": {
        "1786473318163677": "done"
      }
    },
    {
      "id": "1786497988765088",
      "type": "Segmentation",
      "x": 100.0,
      "y": 585.0,
      "params": {
        "mode": "blocks",
        "includedMarkers": {
          "window|Open": true,
          "window|Closed": true
        },
        "eventWindowStartMs": -200.0,
        "eventWindowStopMs": 800.0,
        "eventApplyBaseline": false,
        "eventBaselineConfigured": false,
        "eventBaselineStartMs": -200.0,
        "eventBaselineStopMs": 0.0,
        "blockConcatenate": true,
        "blockInvert": false,
        "equalWindowWidthMs": 1000.0,
        "equalWindowOverlapPercent": 0.0,
        "windowMarkerName": "FFT Window",
        "selectedDatasetIds": [
          "1786473318163677"
        ],
        "storagePolicy": "automatic",
        "segmented_condition_mode": "natural",
        "segmented_channel_mode": "natural",
        "segmented_segment_mode": "natural",
        "segmented_include_bad": false,
        "segmented_visible_marker_labels": [
          "Open",
          "Closed"
        ],
        "segmented_marker_filter_initialized": true,
        "window_sec": 1.0,
        "y_scale_uv": 100.0,
        "channel_spacing_factor": 1.0
      },
      "markerChange": {
        "rows": []
      },
      "datasetStates": {
        "1786473318163677": "done"
      }
    },
    {
      "id": "1786498136451047",
      "type": "Edit Channels",
      "x": 100.0,
      "y": 450.0,
      "params": {
        "channelEditsByDataset": {
          "1786473318163677": {
            "edits": {
              "18": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "M2"
              },
              "12": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "M1"
              }
            },
            "newChannels": [],
            "visibleChannelIndices": [
              0,
              12,
              18
            ],
            "coordinateImportMode": "standard",
            "rereferenceMode": "none"
          }
        },
        "selectedDatasetIds": [
          "1786473318163677"
        ],
        "storagePolicy": "prefer_ram"
      },
      "markerChange": {
        "rows": []
      },
      "datasetStates": {
        "1786473318163677": "done"
      }
    },
    {
      "id": "1786498238633123",
      "type": "Edit Markers",
      "x": 100.0,
      "y": 360.0,
      "params": {
        "markers": [
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 12894531,
            "durationMicros": 0,
            "label": "62",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 62,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 12.894531,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 21296875,
            "durationMicros": 20005859,
            "label": "Open",
            "markerType": "window",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT",
              "brainstory.boundaryStartLabel": "11",
              "brainstory.boundaryStopLabel": "12"
            },
            "timeSeconds": 21.296875,
            "kind": "window"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 22794922,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 22.794922,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 24798828,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 24.798828,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 26800781,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 26.800781,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 28798828,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 28.798828,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 30798828,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 30.798828,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 32798828,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 32.798828,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 34798828,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 34.798828,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 36798828,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 36.798828,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 38798828,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 38.798828,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 40798828,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 40.798828,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 56150391,
            "durationMicros": 20000000,
            "label": "Open",
            "markerType": "window",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT",
              "brainstory.boundaryStartLabel": "11",
              "brainstory.boundaryStopLabel": "12"
            },
            "timeSeconds": 56.150391,
            "kind": "window"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 57646484,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 57.646484,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 59648438,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 59.648438,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 61646484,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 61.646484,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 63646484,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 63.646484,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 65648438,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 65.648438,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 67648438,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 67.648438,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 69646484,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 69.646484,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 71648438,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 71.648438,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 73644531,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 73.644531,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 75644531,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 75.644531,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 82230469,
            "durationMicros": 20068359,
            "label": "Open",
            "markerType": "window",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT",
              "brainstory.boundaryStartLabel": "11",
              "brainstory.boundaryStopLabel": "12"
            },
            "timeSeconds": 82.230469,
            "kind": "window"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 83748047,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 83.748047,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 85759766,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 85.759766,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 87763672,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 87.763672,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 89763672,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 89.763672,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 91763672,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 91.763672,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 93779297,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 93.779297,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 95781250,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 95.78125,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 97794922,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 97.794922,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 99796875,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 99.796875,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 101794922,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 101.794922,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 107962891,
            "durationMicros": 20050781,
            "label": "Open",
            "markerType": "window",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT",
              "brainstory.boundaryStartLabel": "11",
              "brainstory.boundaryStopLabel": "12"
            },
            "timeSeconds": 107.962891,
            "kind": "window"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 109480469,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 109.480469,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 111494141,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 111.494141,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 113492188,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 113.492188,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 115494141,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 115.494141,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 117494141,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 117.494141,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 119496094,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 119.496094,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 121492188,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 121.492188,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 123494141,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 123.494141,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 125494141,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 125.494141,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 127492188,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 127.492188,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 132511719,
            "durationMicros": 20015625,
            "label": "Closed",
            "markerType": "window",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 13,
              "ant.triggerType": 4,
              "source": "ANT CNT",
              "brainstory.boundaryStartLabel": "13",
              "brainstory.boundaryStopLabel": "14"
            },
            "timeSeconds": 132.511719,
            "kind": "window"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 161576172,
            "durationMicros": 20019531,
            "label": "Open",
            "markerType": "window",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT",
              "brainstory.boundaryStartLabel": "11",
              "brainstory.boundaryStopLabel": "12"
            },
            "timeSeconds": 161.576172,
            "kind": "window"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 163074219,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 163.074219,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 165076172,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 165.076172,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 167076172,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 167.076172,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 169076172,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 169.076172,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 171091797,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 171.091797,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 173091797,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 173.091797,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 175091797,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 175.091797,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 177089844,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 177.089844,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 179091797,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 179.091797,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 181091797,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 181.091797,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 189890625,
            "durationMicros": 20015625,
            "label": "Open",
            "markerType": "window",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT",
              "brainstory.boundaryStartLabel": "11",
              "brainstory.boundaryStopLabel": "12"
            },
            "timeSeconds": 189.890625,
            "kind": "window"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 191390625,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 191.390625,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 193390625,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 193.390625,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 195390625,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 195.390625,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 197390625,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 197.390625,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 199390625,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 199.390625,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 201390625,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 201.390625,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 203390625,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 203.390625,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 205408203,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 205.408203,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 207408203,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 207.408203,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 209408203,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 209.408203,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 216984375,
            "durationMicros": 20003906,
            "label": "Open",
            "markerType": "window",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT",
              "brainstory.boundaryStartLabel": "11",
              "brainstory.boundaryStopLabel": "12"
            },
            "timeSeconds": 216.984375,
            "kind": "window"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 218486328,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 218.486328,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 220490234,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 220.490234,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 222486328,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 222.486328,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 224488281,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 224.488281,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 226490234,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 226.490234,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 228486328,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 228.486328,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 230488281,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 230.488281,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 232484375,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 232.484375,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 234484375,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 234.484375,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 236486328,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 236.486328,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 243134766,
            "durationMicros": 20021484,
            "label": "Open",
            "markerType": "window",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT",
              "brainstory.boundaryStartLabel": "11",
              "brainstory.boundaryStopLabel": "12"
            },
            "timeSeconds": 243.134766,
            "kind": "window"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 244636719,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 244.636719,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 246638672,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 246.638672,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 248654297,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 248.654297,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 250654297,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 250.654297,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 252652344,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 252.652344,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 254654297,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 254.654297,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 256652344,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 256.652344,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 258652344,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 258.652344,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 260652344,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 260.652344,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 262652344,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 262.652344,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 266455078,
            "durationMicros": 20011719,
            "label": "Closed",
            "markerType": "window",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 13,
              "ant.triggerType": 4,
              "source": "ANT CNT",
              "brainstory.boundaryStartLabel": "13",
              "brainstory.boundaryStopLabel": "14"
            },
            "timeSeconds": 266.455078,
            "kind": "window"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 293468750,
            "durationMicros": 20017578,
            "label": "Open",
            "markerType": "window",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT",
              "brainstory.boundaryStartLabel": "11",
              "brainstory.boundaryStopLabel": "12"
            },
            "timeSeconds": 293.46875,
            "kind": "window"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 294984375,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 294.984375,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 296982422,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 296.982422,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 298986328,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 298.986328,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 300984375,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 300.984375,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 302984375,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 302.984375,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 304982422,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 304.982422,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 306984375,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 306.984375,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 308978516,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 308.978516,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 310984375,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 310.984375,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 312984375,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 312.984375,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 320982422,
            "durationMicros": 20003906,
            "label": "Open",
            "markerType": "window",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT",
              "brainstory.boundaryStartLabel": "11",
              "brainstory.boundaryStopLabel": "12"
            },
            "timeSeconds": 320.982422,
            "kind": "window"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 322482422,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 322.482422,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 324484375,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 324.484375,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 326484375,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 326.484375,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 328482422,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 328.482422,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 330480469,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 330.480469,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 332482422,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 332.482422,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 334480469,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 334.480469,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 336482422,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 336.482422,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 338480469,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 338.480469,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 340482422,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 340.482422,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 349615234,
            "durationMicros": 20003907,
            "label": "Open",
            "markerType": "window",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT",
              "brainstory.boundaryStartLabel": "11",
              "brainstory.boundaryStopLabel": "12"
            },
            "timeSeconds": 349.615234,
            "kind": "window"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 351115234,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 351.115234,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 353115234,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 353.115234,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 355115234,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 355.115234,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 357115234,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 357.115234,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 359113281,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 359.113281,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 361113281,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 361.113281,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 363113281,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 363.113281,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 365115234,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 365.115234,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 367111328,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 367.111328,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 369113281,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 369.113281,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 375748047,
            "durationMicros": 20035156,
            "label": "Open",
            "markerType": "window",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT",
              "brainstory.boundaryStartLabel": "11",
              "brainstory.boundaryStopLabel": "12"
            },
            "timeSeconds": 375.748047,
            "kind": "window"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 377246094,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 377.246094,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 379246094,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 379.246094,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 381246094,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 381.246094,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 383246094,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 383.246094,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 385246094,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 385.246094,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 387246094,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 387.246094,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 389246094,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 389.246094,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 391250000,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 391.25,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 393261719,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 393.261719,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 395261719,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 395.261719,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 398314453,
            "durationMicros": 20011719,
            "label": "Closed",
            "markerType": "window",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 13,
              "ant.triggerType": 4,
              "source": "ANT CNT",
              "brainstory.boundaryStartLabel": "13",
              "brainstory.boundaryStopLabel": "14"
            },
            "timeSeconds": 398.314453,
            "kind": "window"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 426498047,
            "durationMicros": 20031250,
            "label": "Open",
            "markerType": "window",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT",
              "brainstory.boundaryStartLabel": "11",
              "brainstory.boundaryStopLabel": "12"
            },
            "timeSeconds": 426.498047,
            "kind": "window"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 428009766,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 428.009766,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 430009766,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 430.009766,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 432027344,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 432.027344,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 434027344,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 434.027344,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 436025391,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 436.025391,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 438027344,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 438.027344,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 440027344,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 440.027344,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 442027344,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 442.027344,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 444027344,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 444.027344,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 446023438,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 446.023438,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 451962891,
            "durationMicros": 20048828,
            "label": "Open",
            "markerType": "window",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT",
              "brainstory.boundaryStartLabel": "11",
              "brainstory.boundaryStopLabel": "12"
            },
            "timeSeconds": 451.962891,
            "kind": "window"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 453476563,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 453.476563,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 455478516,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 455.478516,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 457490234,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 457.490234,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 459488281,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 459.488281,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 461492188,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 461.492188,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 463492188,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 463.492188,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 465494141,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 465.494141,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 467507813,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 467.507813,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 469509766,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 469.509766,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 471505859,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 471.505859,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 478855469,
            "durationMicros": 20005859,
            "label": "Open",
            "markerType": "window",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT",
              "brainstory.boundaryStartLabel": "11",
              "brainstory.boundaryStopLabel": "12"
            },
            "timeSeconds": 478.855469,
            "kind": "window"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 480357422,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 480.357422,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 482353516,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 482.353516,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 484353516,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 484.353516,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 486357422,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 486.357422,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 488357422,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 488.357422,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 490357422,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 490.357422,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 492355469,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 492.355469,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 494355469,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 494.355469,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 496355469,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 496.355469,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 498355469,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 498.355469,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 504789063,
            "durationMicros": 20052734,
            "label": "Open",
            "markerType": "window",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT",
              "brainstory.boundaryStartLabel": "11",
              "brainstory.boundaryStopLabel": "12"
            },
            "timeSeconds": 504.789063,
            "kind": "window"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 506289063,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 506.289063,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 508289063,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 508.289063,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 510289063,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 510.289063,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 512287109,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 512.287109,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 514289063,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 514.289063,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 516304688,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 516.304688,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 518304688,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 518.304688,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 520304688,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 520.304688,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 522322266,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 522.322266,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 524335938,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 524.335938,
            "kind": "event"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 527923828,
            "durationMicros": 20011719,
            "label": "Closed",
            "markerType": "window",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 13,
              "ant.triggerType": 4,
              "source": "ANT CNT",
              "brainstory.boundaryStartLabel": "13",
              "brainstory.boundaryStopLabel": "14"
            },
            "timeSeconds": 527.923828,
            "kind": "window"
          },
          {
            "datasetId": "1786473318163677",
            "onsetMicros": 548253906,
            "durationMicros": 0,
            "label": "63",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 63,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 548.253906,
            "kind": "event"
          }
        ],
        "applyEmptyMarkerSet": true,
        "selectedDatasetIds": [
          "1786473318163677"
        ]
      },
      "markerChange": {
        "rows": []
      },
      "datasetStates": {
        "1786473318163677": "done"
      }
    },
    {
      "id": "1786498338381627",
      "type": "PSD",
      "x": 100.0,
      "y": 720.0,
      "params": {
        "fLow": 1.0,
        "fHigh": 40.0,
        "outputMode": "averaged",
        "useParentSegments": false,
        "parentSegmentsNodeId": "1786497988765088",
        "windowing": "hamming",
        "windowLengthSec": 2.0,
        "windowOverlapPercent": 10,
        "selectedDatasetIds": [
          "1786473318163677"
        ],
        "storagePolicy": "automatic",
        "deferAverageToDownstream": true,
        "psd_view_max_hz": 40.0,
        "psd_view_scale_mode": "auto",
        "psd_view_max_power": 10.0,
        "psd_view_log_y": true,
        "psd_condition_mode": "separate"
      },
      "markerChange": {
        "rows": []
      },
      "datasetStates": {
        "1786473318163677": "done"
      }
    },
    {
      "id": "1786498378559390",
      "type": "Average Spectra",
      "x": 100.0,
      "y": 855.0,
      "params": {
        "selectedDatasetIds": [
          "1786473318163677"
        ],
        "storagePolicy": "automatic",
        "psd_view_max_hz": 40.0,
        "psd_view_scale_mode": "auto",
        "psd_view_max_power": 10.0,
        "psd_view_log_y": true,
        "psd_condition_mode": "overlay"
      },
      "markerChange": {
        "rows": []
      },
      "datasetStates": {
        "1786473318163677": "done"
      }
    },
    {
      "id": "1786498839009789",
      "type": "Edit Channels",
      "x": 600.0,
      "y": 225.0,
      "params": {
        "channelEditsByDataset": {
          "1786473318163677": {
            "edits": {
              "12": {
                "rename": "",
                "remove": false,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "T7"
              },
              "18": {
                "rename": "",
                "remove": false,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "CP1"
              }
            },
            "newChannels": [],
            "visibleChannelIndices": [
              12,
              18
            ],
            "coordinateImportMode": "standard",
            "rereferenceMode": "average"
          }
        },
        "selectedDatasetIds": [
          "1786473318163677"
        ],
        "storagePolicy": "prefer_ram"
      },
      "markerChange": {
        "rows": []
      },
      "datasetStates": {
        "1786473318163677": "done"
      }
    },
    {
      "id": "1786498839009836",
      "type": "Edit Markers",
      "x": 600.0,
      "y": 585.0,
      "params": {
        "markers": [
          {
            "onsetMicros": 1312500,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:1312500:337891"
            },
            "timeSeconds": 1.3125,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 1845703,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:1845703:337891"
            },
            "timeSeconds": 1.845703,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 4962891,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:4962891:337891"
            },
            "timeSeconds": 4.962891,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 11238281,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:11238281:337891"
            },
            "timeSeconds": 11.238281,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 12894531,
            "durationMicros": 0,
            "label": "62",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 62,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 12.894531,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 14888672,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:14888672:337891"
            },
            "timeSeconds": 14.888672,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 17026254,
            "durationMicros": 332383,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:1786498808918259"
            },
            "timeSeconds": 17.026254,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 18580078,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:18580078:337891"
            },
            "timeSeconds": 18.580078,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 21296875,
            "durationMicros": 0,
            "label": "11",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 21.296875,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 21881075,
            "durationMicros": 332885,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:1786498811266890"
            },
            "timeSeconds": 21.881075,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 22794922,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 22.794922,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 24798828,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 24.798828,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 26800781,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 26.800781,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 27589196,
            "durationMicros": 379027,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:1786498814751881"
            },
            "timeSeconds": 27.589196,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 28798828,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 28.798828,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 30798828,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 30.798828,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 32798828,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 32.798828,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 34120818,
            "durationMicros": 338759,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:1786498817550063"
            },
            "timeSeconds": 34.120818,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 34798828,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 34.798828,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 36798828,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 36.798828,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 38798828,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 38.798828,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 40798828,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 40.798828,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 41302734,
            "durationMicros": 0,
            "label": "12",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 12,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 41.302734,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 42820313,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:42820313:337891"
            },
            "timeSeconds": 42.820313,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 43968750,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:43968750:337891"
            },
            "timeSeconds": 43.96875,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 50572266,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:50572266:337891"
            },
            "timeSeconds": 50.572266,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 51105469,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:51105469:337891"
            },
            "timeSeconds": 51.105469,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 53812500,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:53812500:337891"
            },
            "timeSeconds": 53.8125,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 55494141,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:55494141:337891"
            },
            "timeSeconds": 55.494141,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 56150391,
            "durationMicros": 0,
            "label": "11",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 56.150391,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 56642578,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:56642578:337891"
            },
            "timeSeconds": 56.642578,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 57646484,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 57.646484,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 59648438,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 59.648438,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 60539063,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:60539063:337891"
            },
            "timeSeconds": 60.539063,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 61646484,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 61.646484,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 63646484,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 63.646484,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 64517578,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:64517578:337891"
            },
            "timeSeconds": 64.517578,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 65648438,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 65.648438,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 67648438,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 67.648438,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 69646484,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 69.646484,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 70300781,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:70300781:337891"
            },
            "timeSeconds": 70.300781,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 71648438,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 71.648438,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 73644531,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 73.644531,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 75644531,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 75.644531,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 76150391,
            "durationMicros": 0,
            "label": "12",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 12,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 76.150391,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 77437500,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:77437500:337891"
            },
            "timeSeconds": 77.4375,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 77724609,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:77724609:337891"
            },
            "timeSeconds": 77.724609,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 79980469,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:79980469:337891"
            },
            "timeSeconds": 79.980469,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 80595703,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:80595703:337891"
            },
            "timeSeconds": 80.595703,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 82230469,
            "durationMicros": 0,
            "label": "11",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 82.230469,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 82646484,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:82646484:337891"
            },
            "timeSeconds": 82.646484,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 83748047,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 83.748047,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 84779297,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:84779297:337891"
            },
            "timeSeconds": 84.779297,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 85759766,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 85.759766,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 87763672,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 87.763672,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 88552734,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:88552734:337891"
            },
            "timeSeconds": 88.552734,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 89763672,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 89.763672,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 91763672,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 91.763672,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 93779297,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 93.779297,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 94541016,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:94541016:337891"
            },
            "timeSeconds": 94.541016,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 95781250,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 95.78125,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 97794922,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 97.794922,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 98642578,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:98642578:337891"
            },
            "timeSeconds": 98.642578,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 99796875,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 99.796875,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 101794922,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 101.794922,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 102298828,
            "durationMicros": 0,
            "label": "12",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 12,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 102.298828,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 103441406,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:103441406:337891"
            },
            "timeSeconds": 103.441406,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 106476563,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:106476563:337891"
            },
            "timeSeconds": 106.476563,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 106845703,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:106845703:337891"
            },
            "timeSeconds": 106.845703,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 107962891,
            "durationMicros": 0,
            "label": "11",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 107.962891,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 108773438,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:108773438:337891"
            },
            "timeSeconds": 108.773438,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 109480469,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 109.480469,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 110455078,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:110455078:337891"
            },
            "timeSeconds": 110.455078,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 111494141,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 111.494141,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 112341797,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:112341797:337891"
            },
            "timeSeconds": 112.341797,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 113492188,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 113.492188,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 114228516,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:114228516:337891"
            },
            "timeSeconds": 114.228516,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 115494141,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 115.494141,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 116484375,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:116484375:337891"
            },
            "timeSeconds": 116.484375,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 117494141,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 117.494141,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 119496094,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 119.496094,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 121492188,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 121.492188,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 123494141,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 123.494141,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 125494141,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 125.494141,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 126246094,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:126246094:337891"
            },
            "timeSeconds": 126.246094,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 127492188,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 127.492188,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 128013672,
            "durationMicros": 0,
            "label": "12",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 12,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 128.013672,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 129158203,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:129158203:337891"
            },
            "timeSeconds": 129.158203,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 129486328,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:129486328:337891"
            },
            "timeSeconds": 129.486328,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 132511719,
            "durationMicros": 0,
            "label": "13",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 13,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 132.511719,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 152527344,
            "durationMicros": 0,
            "label": "14",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 14,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 152.527344,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 157910156,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:157910156:337891"
            },
            "timeSeconds": 157.910156,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 159386719,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:159386719:337891"
            },
            "timeSeconds": 159.386719,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 159837891,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:159837891:337891"
            },
            "timeSeconds": 159.837891,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 160781250,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:160781250:337891"
            },
            "timeSeconds": 160.78125,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 161576172,
            "durationMicros": 0,
            "label": "11",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 161.576172,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 161929688,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:161929688:337891"
            },
            "timeSeconds": 161.929688,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 163074219,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 163.074219,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 163365234,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:163365234:337891"
            },
            "timeSeconds": 163.365234,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 165076172,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 165.076172,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 165785156,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:165785156:337891"
            },
            "timeSeconds": 165.785156,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 166072266,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:166072266:337891"
            },
            "timeSeconds": 166.072266,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 167076172,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 167.076172,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 167794922,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:167794922:337891"
            },
            "timeSeconds": 167.794922,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 169076172,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 169.076172,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 171091797,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 171.091797,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 172019531,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:172019531:337891"
            },
            "timeSeconds": 172.019531,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 173091797,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 173.091797,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 173373047,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:173373047:337891"
            },
            "timeSeconds": 173.373047,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 175091797,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 175.091797,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 175792969,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:175792969:337891"
            },
            "timeSeconds": 175.792969,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 177089844,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 177.089844,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 178212891,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:178212891:337891"
            },
            "timeSeconds": 178.212891,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 179091797,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 179.091797,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 181091797,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 181.091797,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 181595703,
            "durationMicros": 0,
            "label": "12",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 12,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 181.595703,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 181617188,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:181617188:337891"
            },
            "timeSeconds": 181.617188,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 182355469,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:182355469:337891"
            },
            "timeSeconds": 182.355469,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 183626953,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:183626953:337891"
            },
            "timeSeconds": 183.626953,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 184857422,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:184857422:337891"
            },
            "timeSeconds": 184.857422,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 185185547,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:185185547:337891"
            },
            "timeSeconds": 185.185547,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 187564453,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:187564453:337891"
            },
            "timeSeconds": 187.564453,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 188138672,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:188138672:337891"
            },
            "timeSeconds": 188.138672,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 189164063,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:189164063:337891"
            },
            "timeSeconds": 189.164063,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 189492188,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:189492188:337891"
            },
            "timeSeconds": 189.492188,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 189890625,
            "durationMicros": 0,
            "label": "11",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 189.890625,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 191390625,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 191.390625,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 192158203,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:192158203:337891"
            },
            "timeSeconds": 192.158203,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 193390625,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 193.390625,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 194167969,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:194167969:337891"
            },
            "timeSeconds": 194.167969,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 195390625,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 195.390625,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 197390625,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 197.390625,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 198597656,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:198597656:337891"
            },
            "timeSeconds": 198.597656,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 199390625,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 199.390625,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 201390625,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 201.390625,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 202330078,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:202330078:337891"
            },
            "timeSeconds": 202.330078,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 203390625,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 203.390625,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 205408203,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 205.408203,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 206103516,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:206103516:337891"
            },
            "timeSeconds": 206.103516,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 207408203,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 207.408203,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 209408203,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 209.408203,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 209906250,
            "durationMicros": 0,
            "label": "12",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 12,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 209.90625,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 211845703,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:211845703:337891"
            },
            "timeSeconds": 211.845703,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 212789063,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:212789063:337891"
            },
            "timeSeconds": 212.789063,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 214634766,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:214634766:337891"
            },
            "timeSeconds": 214.634766,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 214962891,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:214962891:337891"
            },
            "timeSeconds": 214.962891,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 215496094,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:215496094:337891"
            },
            "timeSeconds": 215.496094,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 216234375,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:216234375:337891"
            },
            "timeSeconds": 216.234375,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 216984375,
            "durationMicros": 0,
            "label": "11",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 216.984375,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 218486328,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 218.486328,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 219310547,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:219310547:337891"
            },
            "timeSeconds": 219.310547,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 220490234,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 220.490234,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 221443359,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:221443359:337891"
            },
            "timeSeconds": 221.443359,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 222486328,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 222.486328,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 224488281,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 224.488281,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 225298828,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:225298828:337891"
            },
            "timeSeconds": 225.298828,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 226490234,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 226.490234,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 228486328,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 228.486328,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 229359375,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:229359375:337891"
            },
            "timeSeconds": 229.359375,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 230488281,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 230.488281,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 231492188,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:231492188:337891"
            },
            "timeSeconds": 231.492188,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 232484375,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 232.484375,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 234484375,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 234.484375,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 235388672,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:235388672:337891"
            },
            "timeSeconds": 235.388672,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 236486328,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 236.486328,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 236988281,
            "durationMicros": 0,
            "label": "12",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 12,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 236.988281,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 238054688,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:238054688:337891"
            },
            "timeSeconds": 238.054688,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 241171875,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:241171875:337891"
            },
            "timeSeconds": 241.171875,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 241623047,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:241623047:337891"
            },
            "timeSeconds": 241.623047,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 242443359,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:242443359:337891"
            },
            "timeSeconds": 242.443359,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 243134766,
            "durationMicros": 0,
            "label": "11",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 243.134766,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 244636719,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 244.636719,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 246638672,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 246.638672,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 248654297,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 248.654297,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 249457031,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:249457031:337891"
            },
            "timeSeconds": 249.457031,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 250654297,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 250.654297,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 252652344,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 252.652344,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 253476563,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:253476563:337891"
            },
            "timeSeconds": 253.476563,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 254654297,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 254.654297,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 256652344,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 256.652344,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 258652344,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 258.652344,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 259095703,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:259095703:337891"
            },
            "timeSeconds": 259.095703,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 259505859,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:259505859:337891"
            },
            "timeSeconds": 259.505859,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 260652344,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 260.652344,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 262652344,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 262.652344,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 263156250,
            "durationMicros": 0,
            "label": "12",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 12,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 263.15625,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 263812500,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:263812500:337891"
            },
            "timeSeconds": 263.8125,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 264837891,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:264837891:337891"
            },
            "timeSeconds": 264.837891,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 266455078,
            "durationMicros": 0,
            "label": "13",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 13,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 266.455078,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 267339844,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:267339844:337891"
            },
            "timeSeconds": 267.339844,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 286466797,
            "durationMicros": 0,
            "label": "14",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 14,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 286.466797,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 287806641,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:287806641:337891"
            },
            "timeSeconds": 287.806641,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 289078125,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:289078125:337891"
            },
            "timeSeconds": 289.078125,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 291498047,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:291498047:337891"
            },
            "timeSeconds": 291.498047,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 291785156,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:291785156:337891"
            },
            "timeSeconds": 291.785156,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 292974609,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:292974609:337891"
            },
            "timeSeconds": 292.974609,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 293468750,
            "durationMicros": 0,
            "label": "11",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 293.46875,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 294984375,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 294.984375,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 295066406,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:295066406:337891"
            },
            "timeSeconds": 295.066406,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 296009766,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:296009766:337891"
            },
            "timeSeconds": 296.009766,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 296982422,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 296.982422,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 297773438,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:297773438:337891"
            },
            "timeSeconds": 297.773438,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 298986328,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 298.986328,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 299824219,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:299824219:337891"
            },
            "timeSeconds": 299.824219,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 300984375,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 300.984375,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 302984375,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 302.984375,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 304212891,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:304212891:337891"
            },
            "timeSeconds": 304.212891,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 304982422,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 304.982422,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 306984375,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 306.984375,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 307699219,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:307699219:337891"
            },
            "timeSeconds": 307.699219,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 308978516,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 308.978516,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 309298828,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:309298828:337891"
            },
            "timeSeconds": 309.298828,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 309667969,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:309667969:337891"
            },
            "timeSeconds": 309.667969,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 310984375,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 310.984375,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 312984375,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 312.984375,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 313400391,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:313400391:337891"
            },
            "timeSeconds": 313.400391,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 313486328,
            "durationMicros": 0,
            "label": "12",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 12,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 313.486328,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 313687500,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:313687500:337891"
            },
            "timeSeconds": 313.6875,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 314466797,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:314466797:337891"
            },
            "timeSeconds": 314.466797,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 315000000,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:315000000:337891"
            },
            "timeSeconds": 315.0,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 316066406,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:316066406:337891"
            },
            "timeSeconds": 316.066406,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 318486328,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:318486328:337891"
            },
            "timeSeconds": 318.486328,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 319224609,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:319224609:337891"
            },
            "timeSeconds": 319.224609,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 320126953,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:320126953:337891"
            },
            "timeSeconds": 320.126953,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 320455078,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:320455078:337891"
            },
            "timeSeconds": 320.455078,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 320982422,
            "durationMicros": 0,
            "label": "11",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 320.982422,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 321357422,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:321357422:337891"
            },
            "timeSeconds": 321.357422,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 322482422,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 322.482422,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 323203125,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:323203125:337891"
            },
            "timeSeconds": 323.203125,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 324484375,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 324.484375,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 326484375,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 326.484375,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 327345703,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:327345703:337891"
            },
            "timeSeconds": 327.345703,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 328482422,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 328.482422,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 330480469,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 330.480469,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 330955078,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:330955078:337891"
            },
            "timeSeconds": 330.955078,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 332482422,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 332.482422,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 334480469,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 334.480469,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 335179688,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:335179688:337891"
            },
            "timeSeconds": 335.179688,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 336482422,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 336.482422,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 337476563,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:337476563:337891"
            },
            "timeSeconds": 337.476563,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 338480469,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 338.480469,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 340482422,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 340.482422,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 340986328,
            "durationMicros": 0,
            "label": "12",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 12,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 340.986328,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 341496094,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:341496094:337891"
            },
            "timeSeconds": 341.496094,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 343875000,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:343875000:337891"
            },
            "timeSeconds": 343.875,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 347525391,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:347525391:337891"
            },
            "timeSeconds": 347.525391,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 348878906,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:348878906:337891"
            },
            "timeSeconds": 348.878906,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 349615234,
            "durationMicros": 0,
            "label": "11",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 349.615234,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 350150391,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:350150391:337891"
            },
            "timeSeconds": 350.150391,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 351115234,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 351.115234,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 353115234,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 353.115234,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 353882813,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:353882813:337891"
            },
            "timeSeconds": 353.882813,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 355115234,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 355.115234,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 357115234,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 357.115234,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 357820313,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:357820313:337891"
            },
            "timeSeconds": 357.820313,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 359113281,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 359.113281,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 361113281,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 361.113281,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 361347656,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:361347656:337891"
            },
            "timeSeconds": 361.347656,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 361839844,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:361839844:337891"
            },
            "timeSeconds": 361.839844,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 363113281,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 363.113281,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 365115234,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 365.115234,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 367111328,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 367.111328,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 369113281,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 369.113281,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 369619141,
            "durationMicros": 0,
            "label": "12",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 12,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 369.619141,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 371109375,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:371109375:337891"
            },
            "timeSeconds": 371.109375,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 371888672,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:371888672:337891"
            },
            "timeSeconds": 371.888672,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 374144531,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:374144531:337891"
            },
            "timeSeconds": 374.144531,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 375005859,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:375005859:337891"
            },
            "timeSeconds": 375.005859,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 375748047,
            "durationMicros": 0,
            "label": "11",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 375.748047,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 376359375,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:376359375:337891"
            },
            "timeSeconds": 376.359375,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 377246094,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 377.246094,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 378492188,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:378492188:337891"
            },
            "timeSeconds": 378.492188,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 379246094,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 379.246094,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 381246094,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 381.246094,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 382019531,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:382019531:337891"
            },
            "timeSeconds": 382.019531,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 383246094,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 383.246094,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 385246094,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 385.246094,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 386531250,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:386531250:337891"
            },
            "timeSeconds": 386.53125,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 387246094,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 387.246094,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 389246094,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 389.246094,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 390140625,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:390140625:337891"
            },
            "timeSeconds": 390.140625,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 391250000,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 391.25,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 393261719,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 393.261719,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 394324219,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:394324219:337891"
            },
            "timeSeconds": 394.324219,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 395261719,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 395.261719,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 395783203,
            "durationMicros": 0,
            "label": "12",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 12,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 395.783203,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 396826172,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:396826172:337891"
            },
            "timeSeconds": 396.826172,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 398314453,
            "durationMicros": 0,
            "label": "13",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 13,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 398.314453,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 418326172,
            "durationMicros": 0,
            "label": "14",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 14,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 418.326172,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 420041016,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:420041016:337891"
            },
            "timeSeconds": 420.041016,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 420369141,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:420369141:337891"
            },
            "timeSeconds": 420.369141,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 422091797,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:422091797:337891"
            },
            "timeSeconds": 422.091797,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 424470703,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:424470703:337891"
            },
            "timeSeconds": 424.470703,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 425701172,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:425701172:337891"
            },
            "timeSeconds": 425.701172,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 426498047,
            "durationMicros": 0,
            "label": "11",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 426.498047,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 426890625,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:426890625:337891"
            },
            "timeSeconds": 426.890625,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 428009766,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 428.009766,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 428326172,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:428326172:337891"
            },
            "timeSeconds": 428.326172,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 430009766,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 430.009766,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 430910156,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:430910156:337891"
            },
            "timeSeconds": 430.910156,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 432027344,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 432.027344,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 432878906,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:432878906:337891"
            },
            "timeSeconds": 432.878906,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 434027344,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 434.027344,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 434765625,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:434765625:337891"
            },
            "timeSeconds": 434.765625,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 436025391,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 436.025391,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 438027344,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 438.027344,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 439277344,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:439277344:337891"
            },
            "timeSeconds": 439.277344,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 440027344,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 440.027344,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 442027344,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 442.027344,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 444027344,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 444.027344,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 446023438,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 446.023438,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 446529297,
            "durationMicros": 0,
            "label": "12",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 12,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 446.529297,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 447603516,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:447603516:337891"
            },
            "timeSeconds": 447.603516,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 450228516,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:450228516:337891"
            },
            "timeSeconds": 450.228516,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 451962891,
            "durationMicros": 0,
            "label": "11",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 451.962891,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 452771484,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:452771484:337891"
            },
            "timeSeconds": 452.771484,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 453476563,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 453.476563,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 453837891,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:453837891:337891"
            },
            "timeSeconds": 453.837891,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 455478516,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 455.478516,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 456339844,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:456339844:337891"
            },
            "timeSeconds": 456.339844,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 457490234,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 457.490234,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 458513672,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:458513672:337891"
            },
            "timeSeconds": 458.513672,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 459488281,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 459.488281,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 461492188,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 461.492188,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 462246094,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:462246094:337891"
            },
            "timeSeconds": 462.246094,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 463492188,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 463.492188,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 465494141,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 465.494141,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 466224609,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:466224609:337891"
            },
            "timeSeconds": 466.224609,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 467507813,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 467.507813,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 468398438,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:468398438:337891"
            },
            "timeSeconds": 468.398438,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 469509766,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 469.509766,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 471505859,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 471.505859,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 472011719,
            "durationMicros": 0,
            "label": "12",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 12,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 472.011719,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 472623047,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:472623047:337891"
            },
            "timeSeconds": 472.623047,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 476150391,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:476150391:337891"
            },
            "timeSeconds": 476.150391,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 477339844,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:477339844:337891"
            },
            "timeSeconds": 477.339844,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 478855469,
            "durationMicros": 0,
            "label": "11",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 478.855469,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 479103516,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:479103516:337891"
            },
            "timeSeconds": 479.103516,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 480357422,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 480.357422,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 482353516,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 482.353516,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 483123047,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:483123047:337891"
            },
            "timeSeconds": 483.123047,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 484353516,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 484.353516,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 486357422,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 486.357422,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 488357422,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 488.357422,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 489521484,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:489521484:337891"
            },
            "timeSeconds": 489.521484,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 490357422,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 490.357422,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 492355469,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 492.355469,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 493212891,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:493212891:337891"
            },
            "timeSeconds": 493.212891,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 494355469,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 494.355469,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 496355469,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 496.355469,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 498355469,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 498.355469,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 498861328,
            "durationMicros": 0,
            "label": "12",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 12,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 498.861328,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 501539063,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:501539063:337891"
            },
            "timeSeconds": 501.539063,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 503015625,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:503015625:337891"
            },
            "timeSeconds": 503.015625,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 504789063,
            "durationMicros": 0,
            "label": "11",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 11,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 504.789063,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 506289063,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 506.289063,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 507240234,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:507240234:337891"
            },
            "timeSeconds": 507.240234,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 508289063,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 508.289063,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 509167969,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:509167969:337891"
            },
            "timeSeconds": 509.167969,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 510289063,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 510.289063,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 512287109,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 512.287109,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 513023438,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:513023438:337891"
            },
            "timeSeconds": 513.023438,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 514289063,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 514.289063,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 515238281,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:515238281:337891"
            },
            "timeSeconds": 515.238281,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 516304688,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 516.304688,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 517083984,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:517083984:337891"
            },
            "timeSeconds": 517.083984,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 518304688,
            "durationMicros": 0,
            "label": "9",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 9,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 518.304688,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 520304688,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 520.304688,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 522322266,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 522.322266,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 523113281,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:523113281:337891"
            },
            "timeSeconds": 523.113281,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 524335938,
            "durationMicros": 0,
            "label": "8",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 8,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 524.335938,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 524841797,
            "durationMicros": 0,
            "label": "12",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 12,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 524.841797,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 526353516,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:526353516:337891"
            },
            "timeSeconds": 526.353516,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 527923828,
            "durationMicros": 0,
            "label": "13",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 13,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 527.923828,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 547935547,
            "durationMicros": 0,
            "label": "14",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 14,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 547.935547,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 548253906,
            "durationMicros": 0,
            "label": "63",
            "markerType": "event",
            "channelMask": [],
            "attributes": {
              "ant.triggerCode": 63,
              "ant.triggerType": 4,
              "source": "ANT CNT"
            },
            "timeSeconds": 548.253906,
            "kind": "event",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 550388672,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:550388672:337891"
            },
            "timeSeconds": 550.388672,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          },
          {
            "onsetMicros": 554203125,
            "durationMicros": 337891,
            "label": "blink",
            "markerType": "artifact",
            "channelMask": [],
            "attributes": {
              "brainstory.interactiveArtifactDetection": true,
              "brainstory.artifactSource": "exemplar",
              "brainstory.artifactStatus": "accepted",
              "brainstory.artifactId": "1786473318163677:blink:554203125:337891"
            },
            "timeSeconds": 554.203125,
            "kind": "artifact",
            "datasetId": "1786473318163677"
          }
        ],
        "applyEmptyMarkerSet": true,
        "selectedDatasetIds": [
          "1786473318163677"
        ]
      },
      "markerChange": {
        "rows": []
      },
      "datasetStates": {
        "1786473318163677": "done"
      }
    },
    {
      "id": "1786498854598994",
      "type": "Segmentation",
      "x": 600.0,
      "y": 765.0,
      "params": {
        "mode": "events",
        "includedMarkers": {
          "event|8": true,
          "event|9": true
        },
        "eventWindowStartMs": -200.0,
        "eventWindowStopMs": 800.0,
        "eventApplyBaseline": false,
        "eventBaselineConfigured": false,
        "eventBaselineStartMs": -200.0,
        "eventBaselineStopMs": 0.0,
        "blockConcatenate": false,
        "blockInvert": false,
        "equalWindowWidthMs": 1000.0,
        "equalWindowOverlapPercent": 0.0,
        "windowMarkerName": "FFT Window",
        "selectedDatasetIds": [
          "1786473318163677"
        ],
        "storagePolicy": "automatic",
        "segmented_condition_mode": "butterfly",
        "segmented_channel_mode": "butterfly",
        "segmented_segment_mode": "average",
        "segmented_include_bad": true,
        "segmented_visible_marker_labels": [
          "9",
          "8"
        ],
        "segmented_marker_filter_initialized": true,
        "window_sec": 1.0,
        "y_scale_uv": 50.0,
        "channel_spacing_factor": 2.0
      },
      "markerChange": {
        "rows": []
      },
      "datasetStates": {
        "1786473318163677": "done"
      }
    },
    {
      "id": "1786557768702445",
      "type": "Bandpass Filter",
      "x": 600.0,
      "y": 405.0,
      "params": {
        "low": 1.0,
        "high": 20.0,
        "steepness": 0.8,
        "notch": 60.0,
        "selectedDatasetIds": [
          "1786473318163677"
        ],
        "storagePolicy": "automatic"
      },
      "markerChange": {
        "rows": []
      },
      "datasetStates": {
        "1786473318163677": "done"
      }
    },
    {
      "id": "1786558350364282",
      "type": "Edit Channels",
      "x": 600.0,
      "y": 855.0,
      "params": {
        "channelEditsByDataset": {
          "1786473318163677": {
            "edits": {
              "0": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "Fp1"
              },
              "1": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "Fpz"
              },
              "2": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "Fp2"
              },
              "3": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "F7"
              },
              "4": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "F3"
              },
              "5": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "Fz"
              },
              "6": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "F4"
              },
              "7": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "F8"
              },
              "8": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "FC5"
              },
              "9": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "FC1"
              },
              "10": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "FC2"
              },
              "11": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "FC6"
              },
              "12": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "T7"
              },
              "13": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "C3"
              },
              "15": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "C4"
              },
              "16": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "T8"
              },
              "17": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "CP5"
              },
              "18": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "CP1"
              },
              "19": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "CP2"
              },
              "20": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "CP6"
              },
              "21": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "P7"
              },
              "22": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "P3"
              },
              "24": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "P4"
              },
              "25": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "P8"
              },
              "26": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "POz"
              },
              "27": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "O1"
              },
              "28": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "O2"
              },
              "29": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "EOG"
              },
              "30": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "AF7"
              },
              "31": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "AF3"
              },
              "32": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "AF4"
              },
              "33": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "AF8"
              },
              "34": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "F5"
              },
              "35": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "F1"
              },
              "36": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "F2"
              },
              "37": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "F6"
              },
              "38": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "FC3"
              },
              "39": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "FCz"
              },
              "40": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "FC4"
              },
              "41": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "C5"
              },
              "42": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "C1"
              },
              "43": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "C2"
              },
              "44": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "C6"
              },
              "45": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "CP3"
              },
              "46": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "CP4"
              },
              "47": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "P5"
              },
              "48": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "P1"
              },
              "49": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "P2"
              },
              "50": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "P6"
              },
              "51": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "PO5"
              },
              "52": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "PO3"
              },
              "53": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "PO4"
              },
              "54": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "PO6"
              },
              "55": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "FT7"
              },
              "56": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "FT8"
              },
              "57": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "TP7"
              },
              "58": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "TP8"
              },
              "59": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "PO7"
              },
              "60": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "PO8"
              },
              "61": {
                "rename": "",
                "remove": true,
                "removeMode": "delete",
                "poolName": "",
                "sourceLabel": "Oz"
              }
            },
            "newChannels": [],
            "visibleChannelIndices": [
              0,
              1,
              2,
              3,
              4,
              5,
              6,
              7,
              8,
              9,
              10,
              11,
              12,
              13,
              14,
              15,
              16,
              17,
              18,
              19,
              20,
              21,
              22,
              23,
              24,
              25,
              26,
              27,
              28,
              29,
              30,
              31,
              32,
              33,
              34,
              35,
              36,
              37,
              38,
              39,
              40,
              41,
              42,
              43,
              44,
              45,
              46,
              47,
              48,
              49,
              50,
              51,
              52,
              53,
              54,
              55,
              56,
              57,
              58,
              59,
              60,
              61
            ],
            "coordinateImportMode": "none",
            "rereferenceMode": "none"
          }
        },
        "selectedDatasetIds": [
          "1786473318163677"
        ],
        "storagePolicy": "prefer_ram"
      },
      "markerChange": {
        "rows": []
      },
      "datasetStates": {
        "1786473318163677": "notReady"
      }
    }
  ],
  "nodeGroups": [],
  "ungroupedAutomaticRootNodeIds": [],
  "connections": [
    {
      "fromNode": "1786497948580428",
      "fromPort": 0,
      "toNode": "1786497961549492",
      "toPort": 0
    },
    {
      "fromNode": "1786498136451047",
      "fromPort": 0,
      "toNode": "1786497988765088",
      "toPort": 0
    },
    {
      "fromNode": "1786497961549492",
      "fromPort": 0,
      "toNode": "1786498238633123",
      "toPort": 0
    },
    {
      "fromNode": "1786498238633123",
      "fromPort": 0,
      "toNode": "1786498136451047",
      "toPort": 0
    },
    {
      "fromNode": "1786497988765088",
      "fromPort": 0,
      "toNode": "1786498338381627",
      "toPort": 1
    },
    {
      "fromNode": "1786498338381627",
      "fromPort": 0,
      "toNode": "1786498378559390",
      "toPort": 0
    },
    {
      "fromNode": "1786497948580428",
      "fromPort": 0,
      "toNode": "1786498839009789",
      "toPort": 0
    },
    {
      "fromNode": "1786498839009836",
      "fromPort": 0,
      "toNode": "1786498854598994",
      "toPort": 0
    },
    {
      "fromNode": "1786498839009789",
      "fromPort": 0,
      "toNode": "1786557768702445",
      "toPort": 0
    },
    {
      "fromNode": "1786557768702445",
      "fromPort": 0,
      "toNode": "1786498839009836",
      "toPort": 0
    }
  ]
}