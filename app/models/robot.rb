require 'sqlite3'
require 'faker'
require 'pry'

class Robot
  attr_reader :name, :city, :state, :department, :id

  def initialize(robot_params)
    @database = SQLite3::Database.new('db/robot_world_development.db')
    @database.results_as_hash = true
    @name = robot_params["name"]
    @city = robot_params["city"]
    @state = robot_params["state"]
    @department = robot_params["department"]
    @id = robot_params["id"] || nil
  end

  def save
   @database.execute("INSERT INTO robots (name, city, state, department) VALUES (?, ?, ?, ?);", @name, @city, @state, @department)
  end

  def self.populate
    6.times do
      database.execute("INSERT INTO robots
                        (name, city, state, department)
                        VALUES (?, ?, ?, ?);",
                        Faker::Name.unique.name,
                        Faker::Address.city,
                        Faker::Address.state_abbr,
                        Faker::Company.bs
                        )
    end
  end

  def self.all
    robots = database.execute("SELECT * FROM robots")
    Robot.populate if robots.empty?
    robots.map do |robot|
      Robot.new(robot)
    end
  end

  def self.find(id)
    robot = database.execute("SELECT * FROM robots WHERE id = ?", id).first
    Robot.new(robot)
  end

  def self.update(id, robot_params)
    database.execute("UPDATE robots
                      SET name = ?,
                          city = ?,
                          state = ?,
                          department = ?
                      WHERE id = ?;",
                      robot_params[:name],
                      robot_params[:city],
                      robot_params[:state],
                      robot_params[:department],
                      id)
    Robot.find(id)
  end

  def self.destroy(id)
    database.execute("DELETE FROM robots
                      WHERE id = ?;", id)
  end

  def self.destroy_all
    # binding.pry
    database.execute("DELETE FROM robots")
  end

  def self.database
    database = SQLite3::Database.new('db/robot_world_development.db')
    database.results_as_hash = true
    database
  end
end
