

class RuleSet
  def initialize(args)
    @rules = args[:rules].map do |rule|
      Rule.new(rule)
    end
  end

  def match(file_name)
    matched = nil
    @rules.each do |rule|
      matched = rule if rule.match(file_name)
    end
    matched
  end
end

class Rule
  def initialize(args)
    @pattern_string = args[:pattern]
    @pattern_owners = args[:pattern_owners]
    @owners = args[:owners]
    @team_owners = args[:team_owners]
  end

  def match(file_name)
    File.fnmatch(@pattern_string, file_name)
  end
end

class CodeOwnerParser

  TEAM_INFO_PREFIX = '# Teams Info:'
  OWNER_INFO_PREFIX = '# users Info:'

  TEAM_NAME_OWNERS_DELIMITER = ' - '
  OWNERS_DELIMITER = ' - '
  SPACE_DELIMITER = ' '
  COMMENT_PREFIX = '#'

  # code owner file location  - File.join(Rails.root, '.github', 'MYCODEOWNERS')
  def initialize(args)
    @code_owner_file_location = args[:code_owner_file_location]
  end


  def parse
    team_owners = {}
    owners = {}
    regex_rules = []
    lines = File.readlines(@code_owner_file_location)
    lines.each do |line|
      line_content = line.dup
      line_content.gsub!(/[\r\n]/, "")
      if line.starts_with?(TEAM_INFO_PREFIX)
        line_content.gsub!(TEAM_INFO_PREFIX, '')

        line_split = line_content.split(TEAM_NAME_OWNERS_DELIMITER)
        team_owners[line_split[0].strip] =  line_split[1].split(' ').map { |c| c.strip }
      elsif line.starts_with?(OWNER_INFO_PREFIX)
        line_content = line.dup
        line_content.gsub!(OWNER_INFO_PREFIX, '')
        owners = line_content.split(SPACE_DELIMITER)
      elsif line.starts_with?(COMMENT_PREFIX)
        next
      else
        contents = line_content.split(" ")
        pattern = contents[0].strip
        pattern_owners = contents[1..-1].map{ |c| c.strip }
        regex_rules << { pattern: pattern, pattern_owners: pattern_owners, team_owners: team_owners, owners: owners }
      end
    end

    { owners: owners, team_owners: team_owners, rules: regex_rules }
  end
end