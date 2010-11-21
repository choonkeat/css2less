#!/usr/bin/ruby
require 'enumerator'

def add_rule(tree, selectors, style)
  return if style.nil? || style.empty?
  if selectors.empty?
    (tree[:style] ||= ';') << style
  else
    first, rest = selectors.first, selectors[1..-1]
    node = (tree[first] ||= {})
    add_rule(node, rest, style)
  end
end

def print_css(output, tree, indent=0)
  tree.each do |element, children|
    output.write ' ' * indent + element + " {\n"
    style = children.delete(:style)
    if style
      output.write style.split(';').map { |s| s.strip }.reject { |s| s.empty? }.map { |s| ' ' * (indent+2) + s + ';' }.join("\n"); output.write "\n"
    end
    print_css(output, children, indent + 2)
    output.write ' ' * indent + "}\n"
  end
end

tree = {}
css = File.read(ARGV[0])
output = ARGV[1] ? open(ARGV[1], 'w') : $stdout
css.split("\n").map { |l| l.strip }.join.gsub(/\/\*+[^\*]*\*+\//, '').split(/[\{\}]/).each_slice(2) do |style|
  rules = style[0].strip
  if rules.include?(',') # leave multiple rules alone
    add_rule(tree, [rules], style[1])
  else
    add_rule(tree, rules.split(/\s+/), style[1])
  end
end

print_css(output, tree)