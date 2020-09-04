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