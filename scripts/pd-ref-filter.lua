-- Generate string
local function split_prepend_ref(inputstr)
  local t = '['
  for str in inputstr:gmatch('([^,]+)') do
    if t ~= '[' then
      t = t..';'
    end
    t = t..'@'..str:gsub('^%s*', ''):gsub('%s*$', '')
  end
  t = t..']'
  return t
end

if FORMAT:match 'markdown' then
  function Link(elem)
    if elem.attributes.reference then
        return pandoc.RawInline('markdown', split_prepend_ref(elem.attributes.reference))
        -- return pandoc.RawInline('markdown', '{+@' ..elem.attributes.reference .. '}')
    else
        return elem
    end
  end
end

if FORMAT:match 'markdown' then
  function Math(elem)
    if elem.mathtype == "DisplayMath" then
      if elem.text:find("\\label") then
        for label in elem.text:gmatch("\\label{(.-)}") do
          elem.text = elem.text:gsub("\\label{"..label.."}", "")
          return pandoc.RawInline('markdown', "$$"..elem.text.."$$".." {#"..label.."}")
        end
      end
    end
    -- tprint(elem, 4)
  end
end

-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
function tprint(tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))      
    else
      print(formatting .. v)
    end
  end
end
