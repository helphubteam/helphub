unless HelpRequest.any?
  points = [
    ['37.66868591308594', '55.71164005362048'],
    ['37.71125793457031', '55.79433344350657'],
    ['37.54852294921875', '55.77502825125135']
  ]

  points.each_with_index do |coordinates, index|
    help_request = HelpRequest.create!(
      lonlat_geojson: { type: 'Point', coordinates: coordinates }.to_json,
      city: 'Moscow',
      district: 'Center',
      street: 'Lenina',
      house: (index + 1).to_s,
      creator: User.moderators.first,
      apartment: '1',
      number: (index + 1).to_s,
      person: 'Some Test Person',
      phone: '+79221111111',
      organization: Organization.first,
      comment: 'comment comment comment'
    )

    HelpRequestLog.create!(
      help_request: help_request,
      kind: 'created',
      user: Organization.first.users.first
    )
  end
end
