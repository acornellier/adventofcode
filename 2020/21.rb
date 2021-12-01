require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'
lines = get_input_str_arr(__FILE__)

foods =
  lines.to_h do |line|
    ingredients, allergens = line.match(/(.*?) \(contains (.*?)\)/)[1..]
    [ingredients.split(' '), allergens.split(', ')]
  end

mapping = {}

5.times do
  foods.each do |ingredients, allergens|
    allergens.each do |allergen|
      already = mapping[allergen]
      conjunction = already ? ingredients.dup & already : ingredients.dup
      mapping[allergen] = conjunction

      if conjunction.size == 1
        mapping.each do |allergen2, ingredients2|
          ingredients2.delete(conjunction[0]) unless allergen == allergen2
        end
      end
    end
  end
end

p mapping

no_allergen_ingredients =
  foods.keys.flatten.uniq.select do |ingredient|
    mapping.values.flatten.uniq.none? do |allergen|
      allergen.include?(ingredient)
    end
  end

count = 0
foods.each do |ingredients, allergens|
  count +=
    ingredients.count do |ingredient|
      no_allergen_ingredients.include?(ingredient)
    end
end

p mapping.sort_by { |k, v| k }.to_h.values.join(',')
