module CardHelper
  def status_to_s(status)
    if status
      'good'
    else
      'bad'
    end
  end
end
