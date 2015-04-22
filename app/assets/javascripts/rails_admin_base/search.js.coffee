$ ->
  # 前月がクリックされた場合
  $(document).on "click", '.search_prev_month' , (event) ->
    prev_date  = last_month()
    start_date =  getMonthStartDate(prev_date.getFullYear(), (prev_date.getMonth()))
    end_date   =  getMonthEndDate(prev_date.getFullYear(), (prev_date.getMonth()))
    date_array = start_end_date_array(start_date, end_date)

    set_select($(@).parent().children('select'),date_array)

  # 今月がクリックされた場合
  $(document).on "click", '.search_this_month' , (event) ->
    date = new Date()
    start_date =  getMonthStartDate(date.getFullYear(), (date.getMonth()))
    end_date   =  getMonthEndDate(date.getFullYear(), (date.getMonth()))
    date_array = start_end_date_array(start_date, end_date)

    set_select($(@).parent().children('select'),date_array)

  # 本日がクリックされた場合
  $(document).on "click", '.search_today' , (event) ->
    date = new Date()
    date_array = start_end_date_array(date, date)

    set_select($(@).parent().children('select'),date_array)

  # クリアがクリックされた場合
  $(document).on "click", '.search_clear' , (event) ->
    $(@).parent().children().each ->
      @.selectedIndex  = 0


  # 開始と終了を配列で返す
  start_end_date_array =(start_date,end_date) ->
    thisyear  = start_date.getFullYear()
    thismonth = (start_date.getMonth() + 1)
    thisday   = start_date.getDate()

    endyear  = end_date.getFullYear()
    endmonth = (end_date.getMonth() + 1)
    endday   = end_date.getDate()

    return [thisyear,thismonth,thisday,endyear,endmonth,endday]

  # 実際に選択する
  set_select =(selectbox, date_array) ->
    idx = 0
    selectbox.each ->
      $(@).val(date_array[idx])
      idx += 1
    @
