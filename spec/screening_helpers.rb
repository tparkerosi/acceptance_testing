# frozen_string_literal: true

COUNTIES = %w[
  alameda alpine amador butte calaveras colusa contra_Costa del_norte el_dorado fresno
  glenn humboldt imperial inyo kern kings lake lassen los_angeles madera marin mariposa mendocino
  merced modoc mono monterey napa nevada orange placer plumas riverside sacramento san_benito
  san_bernardino san_diego san_francisco san_joaquin san_luis_Obispo san_mateo santa_barbara
  santa_clara santa_cruz shasta sierra siskiyou solano sonoma stanislaus sutter tehama trinity
  tulare tuolumne ventura yolo yuba state_of_california
].freeze
COMMUNICATION_METHODS = ['Email', 'Fax', 'In Person', 'Mail', 'Phone'].freeze
ALLEGATION_TYPES = [
  'General neglect', 'Severe neglect', 'Physical abuse', 'Sexual abuse',
  'Emotional abuse', 'Caretaker absent/incapacity', 'Exploitation', 'Sibling at risk'
].freeze
SAFETY_ALERTS = [
  'Dangerous Animal on Premises', 'Dangerous Environment', 'Firearms in Home',
  'Gang Affiliation or Gang Activity', 'Hostile, Aggressive Client',
  'Remote or Isolated Location', 'Severe Mental Health Status',
  'Threat or Assault on Staff Member', 'Other'
].freeze
CROSS_REPORT_AGENCIES = [
  'District attorney', 'Department of justice', 'Law enforcement', 'Licensing'
].freeze
CROSS_REPORT_COMMUNICATION_METHODS = [
  'Child Abuse Form', 'Electronic Report', 'Suspected Child Abuse Report', 'Telephone Report'
].freeze
# Other option exists more than once which causes ambiguity
INCIDENT_LOCATION_TYPES = [
  "Child's Home", "Relative's Home", 'BDDS', 'Camp', 'Day Care', 'Foster Home', 'Hospital',
  'In Public', 'Juvenile Detention', 'Other Home', 'Residential', 'School', 'Unknown'
].freeze
SCREENING_DECISIONS = [
  'Differential response', 'Information to child welfare services',
  'Promote to referral', 'Screen out'
].freeze

module Screening
  def self.screening_information_keys
    %i[name social_worker start_date end_date communication_method]
  end

  def self.incident_information_keys
    %i[incident_date incident_county address city state zip location_type]
  end

  def self.worker_safety_keys
    %i[safety_alerts safety_information]
  end

  def self.keys
    screening_information_keys + incident_information_keys + worker_safety_keys +
      %i[participants narrative cross_reports decision]
  end

  def self.participants(value = nil)
    value || Array.new(rand(0..4)) { Participant.random }
  end

  def self.allegation_types(value = nil)
    value || Array.new(rand(0..5)) { ALLEGATION_TYPES.sample }
  end

  def self.cross_reports(value = nil)
    value || {
      agencies: cross_report_agencies,
      date: generate_date(2016, 2017),
      communication_method: CROSS_REPORT_COMMUNICATION_METHODS.sample
    }
  end

  def self.cross_report_agencies(value = nil)
    return value if value
    agencies = Array.new(rand(0..4)) { CROSS_REPORT_AGENCIES.sample }.uniq
    agencies.map { |agency| { type: agency, name: FFaker::Venue.name } }
  end

  def self.decision(value = nil)
    return value if value
    { screening_decision: screening_decision, additional_information: additional_information,
      access_restrictions: access_restrictions, restrictions_rationale: restrictions_rationale }
  end

  def self.name(value = nil)
    value || FFaker::Movie.title
  end

  def self.social_worker(value = nil)
    value || FFaker::Name.name
  end

  def self.start_date(value = nil)
    value || generate_date(2015, 2016)
  end

  def self.end_date(value = nil)
    value || generate_date(2018)
  end

  def self.communication_method(value = nil)
    value || COMMUNICATION_METHODS.sample
  end

  def self.narrative(value = nil)
    value || FFaker::HipsterIpsum.sentence
  end

  def self.incident_date(value = nil)
    value || generate_date(1970, 2017)
  end

  def self.incident_county(value = nil)
    value || humanize(COUNTIES.sample, capitalize_all: true)
  end

  def self.address(value = nil)
    value || Address.street_address
  end

  def self.city(value = nil)
    value || Address.city
  end

  def self.state(value = nil)
    value || Address.state
  end

  def self.zip(value = nil)
    value || Address.zip
  end

  def self.location_type(value = nil)
    value || INCIDENT_LOCATION_TYPES.sample
  end

  def self.safety_alerts(value = nil)
    value || SAFETY_ALERTS.sample(rand(0...3))
  end

  def self.safety_information(value = nil)
    value || FFaker::CheesyLingo.paragraph
  end

  def self.screening_decision(value = nil)
    value || SCREENING_DECISIONS.sample
  end

  def self.additional_information(value = nil)
    value || FFaker::DizzleIpsum.paragraph
  end

  def self.access_restrictions(value = nil)
    value || 'Do not restrict access'
  end

  def self.restrictions_rationale(value = nil)
    value || FFaker::Lorem.paragraph
  end

  def self.random(attrs = {})
    Screening.keys.each do |key|
      attrs[key] = Screening.send(key, attrs[key])
    end
    attrs
  end

  def self.referral(attrs = {})
    attrs[:participants] = [Participant.victim, Participant.perpetrator, Participant.reporter]
    attrs[:allegations] = {
      field_label: "allegations #{Participant.full_name(attrs[:participants][0])} #{Participant.full_name(attrs[:participants][1])}",
      allegation_types: ['General neglect', 'Severe neglect']
    }
    attrs[:cross_reports] = {
      agencies: [
        { type: 'District attorney', name: FFaker::Venue.name },
        { type: 'Law enforcement', name: FFaker::Venue.name }
      ],
      date: generate_date(2016, 2017),
      communication_method: CROSS_REPORT_COMMUNICATION_METHODS.sample
    }
    attrs[:decision] = {
      screening_decision: 'Promote to referral',
      response_time: '3 days',
      access_restrictions: attrs[:access_restrictions],
      restrictions_rationale: attrs[:restrictions_rationale]
    }
    random(attrs)
  end
end
