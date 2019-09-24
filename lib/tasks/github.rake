# frozen_string_literal: true

def log(str)
  Rails.logger.info str
end

def log_error(str)
  Rails.logger.error str
end

namespace :github do
  desc 'Fetch and import Hacktoberfest projects'
  task fetch_and_import_hacktoberfest_projects: :environment do
    access_token = ENV.fetch('GITHUB_ACCESS_TOKEN')
    api_client = GithubGraphqlApiClient.new(access_token: access_token)
    fetcher = HacktoberfestProjectFetcher.new(api_client: api_client)
    fetcher.fetch!
    projects = fetcher.projects
    importer = HacktoberfestProjectImporter.new
    importer.import_all(projects)
  rescue HacktoberfestProjectFetcherError => e
    log_error(e.message)
  rescue StandardError => e
    log_error(e.message)
  end
end