unless HelpRequest.any?
  points = [
    ['37.66868591308594','55.71164005362048'],
    ['37.71125793457031','55.79433344350657' ],
    ['37.54852294921875','55.77502825125135']
  ]

  points.each_with_index do |coordinates, index|
    HelpRequest.create!(
      lonlat_geojson: { type: 'Point', coordinates: coordinates }.to_json,
      city: "Moscow",
      district: "Center",
      street: "Lenina",
      house: "#{index + 1}",
      apartment: "1",
      person: 'Some Test Person',
      phone: '+79221111111',
      organization: Organization.first
    )
  end
end
