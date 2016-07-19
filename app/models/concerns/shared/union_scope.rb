module Shared::UnionScope
  def self.included(base)
    base.send :extend, ClassMethods
  end
  
  module ClassMethods
    def union_scope(*scopes)
      id_column = "#{table_name}.id"
      
      if (sub_query = scopes.reject { |sc| sc.count == 0 }
          .map { |s| "(#{s.select(id_column).to_sql})" }
          .join(" UNION ")).present?
        where "#{id_column} IN (#{sub_query})"
      else
        none
      end
    end
  end
end
