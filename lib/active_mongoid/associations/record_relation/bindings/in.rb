module ActiveMongoid
  module Associations
    module RecordRelation
      module Bindings
        class In < Associations::Binding

          def bind_one
            check_inverse!(target)
            bind_foreign_key(base, record_id(target))
            bind_polymorphic_inverse_type(base, target.class.name)
            unless _binding?
              _binding do
                if inverse = __metadata__.inverse(target)
                  if set_base_metadata
                    if base.referenced_many_documents?
                      target.__send__(inverse).push(base)
                    else
                      target.set_document_relation(inverse, base)
                    end
                  end
                end
              end
            end
          end

          def unbind_one
            inverse = __metadata__.inverse(target)
            bind_foreign_key(base, nil)
            bind_polymorphic_inverse_type(base, nil)
            unless _binding?
              _binding do
                if inverse
                  set_base_metadata
                  if base.referenced_many_documents?
                    target.__send__(inverse).delete(base)
                  else
                    target.set_document_relation(inverse, nil)
                  end
                end
              end
            end
          end

        end
      end
    end
  end
end
