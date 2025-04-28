if Rails.env.production? || Rails.env.staging?
  Searchkick.aws_credentials = {
    region: ENV.fetch("AWS_REGION", nil),
    credentials_provider: Aws::CredentialProviderChain.new.resolve
  }
end
