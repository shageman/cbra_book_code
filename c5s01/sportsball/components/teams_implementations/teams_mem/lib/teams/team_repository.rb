module Teams
  class TeamRepository
    def get_all
      Teams::Db.get.values
    end

    def get(key)
      id = key.to_i
      Teams::Db.get[id]
    end

    def create(team)
      return team if [nil, ""].include? team.name

      id = Teams::Db.get.keys.max && Teams::Db.get.keys.max + 1 || 1
      Teams::Db.get[id] = Teams::Team.new(id, team.name)
    end

    def update(key, name)
      id = key.to_i
      return false if [nil, ""].include? name

      Teams::Db.get[id] = Teams::Team.new(id, name)
      true
    end

    def delete(key)
      id = key.to_i

      Teams::Db.get.delete(id)
      id
    end
  end
end
