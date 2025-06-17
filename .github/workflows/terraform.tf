name: 'Terraform'

on:
  push:
    branches: [ "main" ]
  pull_request:

permissions:
  contents: read

jobs:
  terraform:
    name: 'Terraform'
    runs-on: ubuntu-latest
    environment: production

    defaults:
      run:
        shell: bash

    steps:
    - name: Checkout Repository
      uses: actions/checkout@v4

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v1
      with:
        cli_config_credentials_token: ${{ secrets.TF_API_TOKEN }}

    - name: Terraform Init
      run: terraform init
      # working-directory: ./terraform  # Uncomment & adjust if files are in a subdirectory

    - name: Terraform Format Check
      run: terraform fmt -check
      # working-directory: ./terraform  # Uncomment & adjust if needed

    - name: Terraform Plan
      run: terraform plan -input=false
      # working-directory: ./terraform  # Uncomment & adjust if needed

    - name: Terraform Apply
      if: github.ref == 'refs/heads/main' && github.event_name == 'push'
      run: terraform apply -auto-approve -input=false
      # working-directory: ./terraform  # Uncomment & adjust if needed
