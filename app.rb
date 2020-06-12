require "sinatra/base"

class App < Sinatra::Base
  get "/" do
    @title = "Car Loan Application CS619"
    @nationalities = { 1 => "Pakistani", 2 => "Indian", 3 => "Other"}
    erb :index
  end

  post "/check_eligibility" do
    @age         = params[:age].to_i
    @status      = params[:status].to_i
    @income      = params[:income].to_i
    @nationality = params[:nationality].to_i
    @cars = { 1 => "Suzuki Mehran VX Euro I", 2 => "Suzuki Mehran VX Euro II", 3 => "Audi A6"}

    if @status == 1 && @age.between?(20,60) && @income >= 50000 && @nationality == 1
      erb :calulate_installment, layout: true
    elsif @status == 2 && @age.between?(22,70) && @income >= 75000 && @nationality == 1
      erb :calulate_installment
    else
      erb :ineligibile
    end
  end

  get "/calculate" do
    @cars = { 1 => "Suzuki Mehran VX Euro I", 2 => "Suzuki Mehran VX Euro II", 3 => "Audi A6"}
    erb :calulate_installment
  end

  post "/calculate" do
    @price             = params[:cost].to_i
    @down_payment      = params[:downPayment].to_i
    @intsallment_years = params[:noOfYears].to_i
    @markup = params[:markUpRate].to_i

    @d_pay_percentage = (@down_payment.to_f / @price) * 100

    unless @d_pay_percentage.to_i.between?(20,50)
      @msg =  "Down Payment #{@d_pay_percentage.to_i}% Down Payment must be between 20-50%"
      return erb :error, layout: true
    end

    # if !(d_pay_percentage.to_i.between?(20,50)) && !(@markup.between?(10,15))
    #   return "Mark up rate must be between 10-15% <br> Down Payment #{d_pay_percentage.to_i}% Down Payment must be between 20-50%"
    # end

    unless @markup.between?(10,15)
      @msg =  "Mark up rate is #{@markup}%, must be between 10-15%"
      return erb :error, layout: true
    end

    price_aftr_down_pay = @price - @down_payment
    @installment_x_yrs = price_aftr_down_pay / (@intsallment_years * 12)
    annum_mrk = (price_aftr_down_pay * 0.12) / 12
    @monthly_installment = @installment_x_yrs + annum_mrk

    erb :result, layout: true
  end
end
