if FORMAT:match 'markdown' then

  function Link(elem)

    if elem.attributes.reference then
        return pandoc.RawInline('markdown', '[@' ..elem.attributes.reference .. ']')
        -- return pandoc.RawInline('markdown', '{+@' ..elem.attributes.reference .. '}')
    else
        return elem
    end

  end

end

function dump(file, t, indent, done)
  done = done or {}
  indent = indent or 0

  done[t] = true

  for key, value in pairs(t) do
      file:write(string.rep("\t", indent))

      if (type(value) == "table" and not done[value]) then
          done[value] = true
          file:write(key, ":\n")

          dump(file, value, indent + 2, done)
          done[value] = nil
      else
          file:write(key, "\t=\t", value, "\n")
      end
  end
end
