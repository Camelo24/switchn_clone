package com.switchn.backend.model;

public class TransactionResponse {
    private String transactionId;
    private String timestamp;
    private String type;
    private NetworkType network;
    private String recipient;
    private Double amount;
    private String status;
    private String message;

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public NetworkType getNetwork() {
        return network;
    }

    public void setNetwork(NetworkType network) {
        this.network = network;
    }

    public String getRecipient() {
        return recipient;
    }

    public void setRecipient(String recipient) {
        this.recipient = recipient;
    }

    public Double getAmount() {
        return amount;
    }

    public void setAmount(Double amount) {
        this.amount = amount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public static Builder builder() {
        return new Builder();
    }

    public static final class Builder {
        private final TransactionResponse response = new TransactionResponse();

        public Builder transactionId(String transactionId) {
            response.setTransactionId(transactionId);
            return this;
        }

        public Builder timestamp(String timestamp) {
            response.setTimestamp(timestamp);
            return this;
        }

        public Builder type(String type) {
            response.setType(type);
            return this;
        }

        public Builder network(NetworkType network) {
            response.setNetwork(network);
            return this;
        }

        public Builder recipient(String recipient) {
            response.setRecipient(recipient);
            return this;
        }

        public Builder amount(Double amount) {
            response.setAmount(amount);
            return this;
        }

        public Builder status(String status) {
            response.setStatus(status);
            return this;
        }

        public Builder message(String message) {
            response.setMessage(message);
            return this;
        }

        public TransactionResponse build() {
            return response;
        }
    }
}
