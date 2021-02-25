if FORMAT:match 'markdown' then

  function Image(elem)
    -- Make sure extension is .png
    elem.src = elem.src:gsub("%.pdf", ".png")

    -- Prepend figure directory
    elem.src = "figs/" .. elem.src
    return elem
  end

end

-- Filter images with this function if the target format is HTML
if FORMAT:match 'html' then
  function Image(elem)
    elem.attributes.style = 'cursor:pointer'
    elem.attributes.onclick = 'onClickImage(this)'
    return elem
  end
end