require 'rubygems'
require 'inline'

class Object
  inline(:C) do |builder|
    builder.c %{
      VALUE unextend(VALUE mod) 
      {
        VALUE p, prev;
        Check_Type(mod, T_MODULE);
        
        p = (TYPE(self) == T_CLASS) ? self : rb_singleton_class(self);
        
        while (p) {
            if (p == mod || RCLASS(p)->m_tbl == RCLASS(mod)->m_tbl) {
                RCLASS(prev)->super = RCLASS(p)->super;
                rb_clear_cache();
                return self;
            }
            prev = p;
            p = RCLASS(p)->super;
        }
        return self;
      }
    }
  end

end
