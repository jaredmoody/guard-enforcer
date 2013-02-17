# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'guard-enforcer'
  s.version     = '0.0.1'
  s.authors     = ['Jared Moody']
  s.email       = ['jared@jaredmoody.com']
  s.homepage    = 'http://github.com/jaredmoody/guard-enforcer'
  s.summary     = %q{Enforce guard runs}
  s.description = %q{guard-enforcer makes sure guard has run before you commit}

  s.add_dependency 'guard'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map {|f| File.basename(f) }
  s.require_paths = ['lib']
end
