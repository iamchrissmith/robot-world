require 'sqlite3'

class Robot
  attr_reader :title, :city, :state, :department, :id

  def initialize(robot_params)
    @database = SQLite3::Database.new('db/robot_world_development.db')
    @database.results_as_hash = true
    @title = robot_params["title"]
    @city = robot_params["city"]
    @state = robot_params["state"]
    @department = robot_params["department"]
    @id = robot_params["id"] || nil
  end

  def save
   @database.execute("INSERT INTO robots (title, city, state, department) VALUES (?, ?, ?, ?);", @title, @city, @state, @description)
  end

  def self.all
    robots = database.execute("SELECT * FROM robots")
    robots.map do |robot|
      Robot.new(robot)
    end
  end

  def self.database
    database = SQLite3::Database.new('db/robot_world_development.db')
    database.results_as_hash = true
    database
    
  end
end
