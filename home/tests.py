from django.conf import settings
from django.test import Client, TestCase
from django.urls import reverse


class HomeViewsTest(TestCase):
    def setUp(self):
        self.client = Client()

    def test_home_template(self):
        url = reverse("home-view")
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed(response, "home/index.html")
