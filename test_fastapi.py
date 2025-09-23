#!/usr/bin/env python3
"""
Test script เพื่อทดสอบ FastAPI endpoint โดยตรง
"""
import requests
import json

# Test data
url = "http://localhost:8000/api/v1/auth/login"
test_data = {
    "username": "6510110111@gmail.com",
    "password": "12345678"
}

print("🧪 Testing FastAPI Login Endpoint...")
print(f"URL: {url}")

# Test 1: JSON data
print("\n--- Test 1: JSON Content-Type ---")
try:
    response = requests.post(
        url,
        json=test_data,
        headers={"Content-Type": "application/json", "Accept": "application/json"}
    )
    print(f"Status: {response.status_code}")
    print(f"Response: {response.text}")
except Exception as e:
    print(f"Error: {e}")

# Test 2: Form data
print("\n--- Test 2: Form Data Content-Type ---")
try:
    response = requests.post(
        url,
        data=test_data,
        headers={"Content-Type": "application/x-www-form-urlencoded", "Accept": "application/json"}
    )
    print(f"Status: {response.status_code}")
    print(f"Response: {response.text}")
except Exception as e:
    print(f"Error: {e}")

# Test 3: OAuth2 Form
print("\n--- Test 3: OAuth2 Password Flow ---")
try:
    oauth_data = {
        "grant_type": "password",
        "username": "6510110111@gmail.com",
        "password": "12345678"
    }
    response = requests.post(
        url,
        data=oauth_data,
        headers={"Content-Type": "application/x-www-form-urlencoded", "Accept": "application/json"}
    )
    print(f"Status: {response.status_code}")
    print(f"Response: {response.text}")
except Exception as e:
    print(f"Error: {e}")