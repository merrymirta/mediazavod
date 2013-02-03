class PagesController < ApplicationController
  layout "pages"

  def home
    @hot_shorties = Shorty.publicated_at_homepage.find(:all, :limit => 15)
    @hot_articles = Article.publicated_as_hot.find(:all, :limit => 3)
    
    @sections = Section.visible_at_homepage.roots

    @user_articles = UserArticle.latest.by_state(:featured).find(:all, :limit => 3)
  end
  

  def header
    render :partial => "layouts/header"
  end

  def footer
    render :partial => "layouts/footer"
  end

=begin
Алгоритм проверки качества водки:

берем цифры штрих-кода (их 13)
пример: 4607104940476

1. складываем цифры, стоящие на четных позициях
пример: 6+7+0+9+0+7=29


2. утраиваем полученную сумму
пример: 29х3=87


3. складываем цифры на нечетных позициях (кроме последней)
пример: 4+0+1+4+4+4=17

4. суммируем результаты второго и третьего действий
пример: 87+17=104

5. вычитаем полученную сумму из ближайшего числа, кратного 10 (большего, чем эта сумма)
пример: 110-104=6

6. полученное число должно быть таким же, как последняя цифра штрих-кода. если да - водка настоящая, если нет, то она контрафактная.
пример: 6=6 - водка хорошая
=end
  def vodka
    if request.post?
      @code = params[:code].to_s.gsub(/[^\d]/, "")

      if @code.length < 13
        @result = "Неправильный штрих-код"
      else
        #4600298000186
        a = [1,3,5,7,9,11].collect{|i| @code[i, 1].to_i }.sum
        b = a * 3
        c = [0,2,4,6,8,10].collect{|i| @code[i, 1].to_i }.sum
        d = b + c
        e = ((d.to_f + 0.0001) / 10).ceil * 10 - d

        x = @code[12, 1].to_i

        logger.debug "a: #{a} b: #{b} c: #{c} d: #{d} e: #{e} x: #{x}"

        if e == x
          @result = "Скорее всего, водка настоящая"
        else
          @result = "Скорее всего, это поддельная водка"
        end
      end
    end
  end
end