-- Configure user, role, db, and schema
SET USERNAME = (SELECT CURRENT_USER());
SELECT $USERNAME;
USE ROLE E2E_SNOW_MLOPS_ROLE;
USE WAREHOUSE E2E_SNOW_MLOPS_WH;
USE DATABASE E2E_SNOW_MLOPS_DB_CG;
USE SCHEMA MLOPS_SCHEMA;

-- Create new compute pool
CREATE COMPUTE POOL IF NOT EXISTS MLOPS_COMPUTE_POOL
    MIN_NODES = 1
    MAX_NODES = 5
    INSTANCE_FAMILY = GPU_NV_2M;

-- Enable external integration with pypi
CREATE OR REPLACE NETWORK RULE mlops_pypi_network_rule
    MODE = EGRESS
    TYPE = HOST_PORT
    VALUE_LIST = ('pypi.org', 'pypi.python.org', 'pythonhosted.org',  'files.pythonhosted.org');
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION mlops_pypi_access_integration
    ALLOWED_NETWORK_RULES = (mlops_pypi_network_rule)
    ENABLED = true;

-- Create API integration with Git, fetch
CREATE OR REPLACE API INTEGRATION GIT_INTEGRATION_RISK_RANK_TEST
    api_provider = git_https_api
    api_allowed_prefixes = ('https://github.com/CGrajedaMPC')
    enabled = true
    comment='Git integration with test repo';
CREATE OR REPLACE GIT REPOSITORY GIT_REPO_RISK_RANK_TEST
    ORIGIN = 'https://github.com/CGrajedaMPC/riskrank-snowsql-test' 
    API_INTEGRATION = 'GIT_INTEGRATION_RISK_RANK_TEST' 
    COMMENT = 'Risk Rank Test Github Repository';
ALTER GIT REPOSITORY GIT_REPO_RISK_RANK_TEST FETCH;

