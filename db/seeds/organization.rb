unless Organization.any?
  Organization.create!(
      title: 'Орзанизация_1',
      country: 'Беларусь',
      city: 'Минск',
      site: 'new_site.by'
  )
end
