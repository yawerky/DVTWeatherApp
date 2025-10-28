# CI/CD Pipeline

## Overview
Simple GitHub Actions workflow that automatically tests and builds the iOS app.

## What It Does

1. **Run Tests** - Executes all unit tests
2. **Build App** - Builds the app in Release configuration

## When It Runs

- On push to `main` or `develop` branches
- On pull requests to `main` branch

## Setup

1. Push this repository to GitHub
2. The workflow runs automatically - no setup needed!

## View Results

Go to your GitHub repository → **Actions** tab to see the build status.

✅ Green checkmark = Tests passed and build successful
❌ Red X = Tests failed or build error
