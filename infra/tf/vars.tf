variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "producer_lambda_name" {
  description = "The name of the producer Lambda function."
  type        = string
  default     = "producer_lambda"
}

variable "consumer_lambda_name" {
  description = "The name of the consumer Lambda function."
  type        = string
  default     = "consumer_lambda"
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table."
  type        = string
  default     = "BookRequests"
}

variable "sqs_queue_name" {
  description = "The name of the SQS queue."
  type        = string
  default     = "book-requests-queue"
}

variable "sqs_dlq_name" {
  description = "The name of the SQS dead-letter queue."
  type        = string
  default     = "book-requests-dlq"
}

variable "api_name" {
  description = "The name of the API Gateway."
  type        = string
  default     = "BookRequestAPI"
}
