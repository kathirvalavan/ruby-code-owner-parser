# ruby-code-owner-parser
A simple parser for code owners detection

similar to https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/about-code-owners
Currently it is ruby specific, but will make it better in par with github in further releases

Pattern matching is dependent on this format https://apidock.com/ruby/File/fnmatch/class

Usage:

ruleSet = CodeOwnerParser.new({ code_owner_file_location: 'CODEOWNERS' }).parse

ruleSet.match('lib/simple_util.rb') -  return Rule if found else nil
