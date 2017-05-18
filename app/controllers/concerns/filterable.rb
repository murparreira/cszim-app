module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filtering_params)
      results = self.where(nil)
      filtering_params.each do |key, value|
        results = results.public_send(key, value) if value.present? && key != :page
      end
      results.paginate(page: filtering_params[:page], per_page: 15)
    end

    def filter_report(filtering_params)
      results = self.where(nil)
      filtering_params.each do |key, value|
        results = results.public_send(key, value) if value.present? && key != :page
      end
      results
    end
  end
end
