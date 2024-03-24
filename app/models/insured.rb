class Insured < ActiveRecord::Base
  self.table_name = "insureds"
  has_many :insurance_policies


  def self.create(insured_name)
    insured = nil
    begin
      insured = Insured.find_or_initialize_by(name: insured_name)
      insured.save!
    rescue ActiveRecord::RecordNotUnique
      Rails.logger.error("")#TODO:Prutha
      return insured
    rescue ActiveRecord::RecordNotSaved
      Rails.logger.error("")#TODO:Prutha
      return insured
    end

    insured
  end
end