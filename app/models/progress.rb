class Progress

attr_reader :goal

  def initialize(goal)
    @goal = goal
  end

  def result
    prepare_api_request
  end

  def prepare_api_request
    case goal.provider.downcase
    when "github"
      github_preparation
    when "exercism"
      exercism_preparation
    when "fitbit"
      "Fitbit not prepared yet"
    else
     "invalid provider"
    end
  end

  def exercism_preparation
    request = ExercismApiRequest.new(days_to_pull, goal.target, goal.api_account.api_username, goal.commit_type, goal.language)
    request.progress
  end

  def github_preparation
    github_request(days_to_pull, goal.target)
  end

  def github_request(days_to_pull, target)
    username = goal.api_account.api_username
    request = GithubApiRequest.new(days_to_pull, target, username)
    request.progress
  end

  def days_to_pull
    case goal.period_type
    when "day", "days"
      1
    when "week", "weeks"
      Date.today.wday
    when "month", "months"
      Date.today.mday
    end
  end

end