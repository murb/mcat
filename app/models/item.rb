class Item < ActiveRecord::Base
  belongs_to :itembank
  belongs_to :choice_option_set, primary_key: :choice_options_id

  accepts_nested_attributes_for :choice_option_set

  default_scope -> {where("items.choice_option_set_id IS NOT NULL AND (ff_alpha IS NOT NULL OR fat_alpha IS NOT NULL OR soc_alpha IS NOT NULL)").order(:created_at)} # mochten genegeerd worden volgens Muirne (20 april 2015)

  def reverse_scale= value
    if value.to_s.strip.downcase == "ja"
      value = true
    end
    write_attribute(:reverse_scale, value)
  end



  def betas(round_to=3)
    beta_1 = [ff_beta1,fat_beta1,soc_beta1].compact.first
    beta_2 = [ff_beta2,fat_beta2,soc_beta2].compact.first
    beta_3 = [ff_beta3,fat_beta3,soc_beta3].compact.first
    beta_4 = [ff_beta4,fat_beta4,soc_beta4].compact.first
    [beta_1.round(round_to), beta_2.round(round_to), beta_3.round(round_to), beta_4.round(round_to)]
  end

  def alphas(round_to=3)
    alpha_1 = ff_alpha ? ff_alpha : 0
    alpha_2 = fat_alpha ? fat_alpha : 0
    alpha_3 = soc_alpha ? soc_alpha : 0

    return [alpha_1.round(round_to), alpha_2.round(round_to), alpha_3.round(round_to)]
  end

  class << self
    def betas
      self.all.collect{|a| a.betas}
    end
    def alphas
      self.all.collect{|a| a.alphas}
    end
    def ids
      @@ids ||= self.all.collect{|a| a.id}
    end
    def index(id)
      ids.index(id)
    end
  end
end
