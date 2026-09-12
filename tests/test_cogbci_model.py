from pathlib import Path
import unittest

from neuroloop.cogbci_model import COGBCI_MODEL_ID, flanker_outcomes
from neuroloop.live_model import load_deployment_model


class CogBciModelTests(unittest.TestCase):
    def test_flanker_events_map_correct_incorrect_and_missed_trials(self):
        outcomes = flanker_outcomes(
            [
                (0.0, "210"),
                (2.0, "241"),
                (2.5, "2511"),
                (5.0, "210"),
                (7.0, "242"),
                (7.8, "2522"),
                (10.0, "210"),
                (12.0, "241"),
                (15.0, "210"),
            ]
        )
        self.assertEqual(outcomes[0], (2.0, False, 0.5))
        self.assertEqual(outcomes[1][:2], (7.0, True))
        self.assertAlmostEqual(outcomes[1][2], 0.8)
        self.assertEqual(outcomes[2], (12.0, True, None))

    def test_repository_contains_trained_cogbci_model(self):
        artifact = (
            Path(__file__).resolve().parents[1]
            / "artifacts"
            / "cogbci_flanker_live_model.joblib"
        )
        model = load_deployment_model(artifact)
        self.assertEqual(model.model_id, COGBCI_MODEL_ID)
        self.assertEqual(model.label, "cogbci_flanker_lapse")
        self.assertEqual(model.evaluation["training_subjects"], [1, 2])
        self.assertEqual(model.evaluation["training_sessions"], 6)


if __name__ == "__main__":
    unittest.main()
