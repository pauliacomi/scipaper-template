if FORMAT:match 'markdown' then

  function Image(elem)
    -- Make sure extension is .png
    elem.src = elem.src:gsub("%.pdf", ".png")
    return elem
  end

end