import requests

from service_tests.test_service_base import ServicesTest


class TestLibraryServices(ServicesTest):
    def test_validate_valid_events_file_with_versions(self):
        """Test that a standard sidecar validates successfully with multiple library schemas loaded."""
        url = f"{self.BASEURL}/services_submit"
        json_data = {
            "service": "events_validate",
            "schema_version": ["8.2.0", "sc:score_1.0.0", "la:lang_1.2.0"],
            "sidecar_string": self.data["jsonText"],
            "events_string": self.data["eventsText"],
            "check_for_warnings": False,
        }
        response = requests.post(url, json=json_data, headers=self._get_headers())
        self.assertEqual(response.status_code, 200)
        response_data = response.json()
        self.assertFalse(response_data.get("error_type"))
        self.assertEqual(response_data["results"]["msg_category"], "success")

    def test_validate_valid_events_file_with_libraries(self):
        """Test that a sidecar using library schema tags validates successfully."""
        url = f"{self.BASEURL}/services_submit"
        json_data = {
            "service": "events_validate",
            "schema_version": ["8.2.0", "sc:score_1.0.0", "la:lang_1.2.0"],
            "sidecar_string": self.data["jsonLibrary"],
            "events_string": self.data["eventsText"],
            "check_for_warnings": False,
        }
        response = requests.post(url, json=json_data, headers=self._get_headers())
        self.assertEqual(response.status_code, 200)
        response_data = response.json()
        self.assertFalse(response_data.get("error_type"))
        self.assertEqual(response_data["results"]["msg_category"], "success")

    def test_validate_events_file_missing_libraries(self):
        """Test that a sidecar with library tags fails when only the standard schema is loaded."""
        url = f"{self.BASEURL}/services_submit"
        json_data = {
            "service": "events_validate",
            "schema_version": "8.2.0",
            "sidecar_string": self.data["jsonLibrary"],
            "events_string": self.data["eventsText"],
            "check_for_warnings": False,
        }
        response = requests.post(url, json=json_data, headers=self._get_headers())
        self.assertEqual(response.status_code, 200)
        response_data = response.json()
        self.assertEqual(response_data["results"]["msg_category"], "warning")
        self.assertIn("TAG_NAMESPACE_PREFIX_INVALID", response_data["results"]["data"])

    def test_validate_events_file_missing_one_library(self):
        """Test that a sidecar with tags from two libraries fails when only one of them is loaded."""
        url = f"{self.BASEURL}/services_submit"
        json_data = {
            "service": "events_validate",
            "schema_version": ["8.2.0", "sc:score_1.0.0"],
            "sidecar_string": self.data["jsonLibrary"],
            "events_string": self.data["eventsText"],
            "check_for_warnings": False,
        }
        response = requests.post(url, json=json_data, headers=self._get_headers())
        self.assertEqual(response.status_code, 200)
        response_data = response.json()
        self.assertEqual(response_data["results"]["msg_category"], "warning")
        self.assertIn("TAG_NAMESPACE_PREFIX_INVALID", response_data["results"]["data"])
        self.assertIn("la:English", response_data["results"]["data"])
        self.assertNotIn("sc:Photic-driving", response_data["results"]["data"])
