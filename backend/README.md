# Switchn Backend

A Java Spring Boot backend for Switchn fintech simulation.

## Overview

This backend provides simulated endpoints for mobile airtime top-up, data bundle purchases, cross-network transfers, and offline transactions in Cameroon.

## Run

```bash
cd backend
mvn spring-boot:run
```

The backend starts on port `8081` by default.

## API Endpoints

- `GET /api/v1/networks`
  - Returns supported network types: MTN, ORANGE, CAMTEL, NEXTTEL, YOOMEE.

- `POST /api/v1/transactions/topup`
  - Simulates airtime top-up.
  - Request body: `network`, `recipient`, `amount`, optional `bundleCode`, `notes`.

- `POST /api/v1/transactions/data-bundle`
  - Simulates data bundle activation.

- `POST /api/v1/transactions/transfer`
  - Simulates cross-network money transfers.

- `POST /api/v1/transactions/offline`
  - Simulates offline transaction submission.

- `GET /api/v1/transactions`
  - Returns simulation transaction history.
