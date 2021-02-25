-- This pandoc lua filter helps with latex chemical formulas with \ce
--      In the case of markdown, it is re-escaped for math mode
--      In the case of docx, the \ce is fully removed

if FORMAT:match 'markdown' then

    function Math(elem)
        elem.text = elem.text:gsub("%\\\\ce", "\\ce")
        return elem
    end

elseif FORMAT:match 'docx' then

    function Math(elem)
        elem.text = elem.text:gsub("%\\ce", "")
        return elem
    end

end