class GamesController < ApplicationController
  def roulette
  end
  def spin_roulette
    chosen = params[:choice]
    bet = params[:bet].to_i.clamp(1, 1000000)

    number = rand(37)
    color = number == 0 ? "zielony" : number.even? ? "czarny" : "czerwony"

    win = 0
    result = ""

    if current_user&.wallet
      current_user.wallet.decrement!(:balance, bet)
      BalanceHistory.create(user: current_user, amount: -bet, reason: "Ruletka bet")

      if chosen == color
        win = bet * 2
        current_user.wallet.increment!(:balance, win)
        BalanceHistory.create(user: current_user, amount: win, reason: "Ruletka wygrana")
        result = "✅ Trafiłeś kolor #{color}! Wygrywasz #{win} żetonów!"
      elsif chosen.to_i.to_s == chosen && chosen.to_i == number
        win = bet * 36
        current_user.wallet.increment!(:balance, win)
        BalanceHistory.create(user: current_user, amount: win, reason: "Ruletka wygrana")
        result = "🎯 Trafiłeś numer #{number}! Wygrywasz #{win} żetonów!"
      else
        result = "❌ Wypadło #{number} (#{color}). Niestety, przegrywasz."
      end
    else
      result = "Brak środków lub niezalogowany."
    end
    logger.info "🎲 spin_roulette start"
    logger.info "🎲 Wybrano: #{chosen}, Bet: #{bet}"
    logger.info "🎯 Wypadło: #{number} (#{color})"
    @result = result
    @number = number
    @color = color
    respond_to do |format|
      format.html { render :roulette }
      format.turbo_stream
    end
    puts "🔁 Parametry ruletki: #{params.inspect}"
    puts "➡️  Wynik: #{@result}"
  end
  

  before_action :authenticate_user!, only: [:blackjack_deal, :blackjack_hit, :blackjack_stand]

  def blackjack
    @player_cards = session[:player_cards] || []
    @dealer_cards = session[:dealer_cards] || []
    @result = session[:blackjack_result]
  end

  def blackjack_deal
    bet = params[:bet].to_i.clamp(1, 1000)

    if current_user.wallet.balance < bet
      flash[:alert] = "❌ Za mało środków!"
      redirect_to blackjack_path and return
    end

  # Odejmij saldo
    current_user.wallet.decrement!(:balance, bet)
    BalanceHistory.create(user: current_user, amount: -bet, reason: "BlackJack start")

  # Zapisz zakład do sesji
    session[:bet] = bet
    session[:blackjack_result] = nil

  # Przygotuj i potasuj talię
    deck = (2..11).to_a * 4
    deck.shuffle!
    session[:deck] = deck

  # Rozdaj karty
    session[:player_cards] = [deck.pop, deck.pop]
    session[:dealer_cards] = [deck.pop, deck.pop]

    redirect_to blackjack_path
  end

  def blackjack_hit
    session[:player_cards] << rand(2..11)
    if session[:player_cards].sum > 21
      session[:blackjack_result] = "💥 Przegrałeś! Masz ponad 21."
    end
    redirect_to blackjack_path
  end

  def blackjack_stand
    while session[:dealer_cards].sum < 17
      session[:dealer_cards] << rand(2..11)
    end

    player_total = session[:player_cards].sum
    dealer_total = session[:dealer_cards].sum


    if dealer_total > 21 || player_total > dealer_total
      session[:blackjack_result] = "🎉 Wygrałeś!"
    elsif dealer_total == player_total
      session[:blackjack_result] = "🤝 Remis!"
    else
      session[:blackjack_result] = "❌ Przegrałeś!"
    end

    redirect_to blackjack_path
  end


  def slots
    puts "⚙️ SLOTY: weszliśmy do metody"
  symbol_pool = [
    ['🍒', 5, 10],
    ['🍋', 5, 15],
    ['🍊', 4, 20],
    ['🍉', 3, 30],
    ['🍇', 3, 40],
    ['💎', 2, 100],
    ['7️⃣', 1, 200]
  ]

  weighted_symbols = symbol_pool.flat_map { |sym, weight, _| [sym] * weight }
  @symbols = weighted_symbols.sample(3)

  counts = @symbols.tally
  max_count = counts.values.max
  winning_symbol = counts.key(max_count)

  symbol_data = symbol_pool.find { |s| s[0] == winning_symbol }
  reward = symbol_data ? symbol_data[2] : 0

  @result =
    case max_count
    when 3
      "🎉 JACKPOT! Trzy #{winning_symbol} – wygrywasz #{reward * 3} żetonów!"
    when 2
      "😊 Dwa #{winning_symbol} – wygrywasz #{reward} żetonów!"
    else
      "😞 Nic nie trafiłeś. Spróbuj ponownie!"
    end


  if current_user && current_user.wallet
    case max_count
    when 3
      current_user.wallet.increment!(:balance, reward * 3)
      BalanceHistory.create(user: current_user, amount: reward * 3, reason: "Slot wygrana")
    when 2
      current_user.wallet.increment!(:balance, reward)
      BalanceHistory.create(user: current_user, amount: reward, reason: "Slot wygrana")
    else
      current_user.wallet.decrement!(:balance, 10)  # koszt gry
      BalanceHistory.create(user: current_user, amount: -10, reason: "Slot przegrana")
    end
  end
  puts "🎰 Wylosowano symbole: #{@symbols.inspect}"
  puts "👛 Saldo: #{current_user.wallet.balance}" if current_user&.wallet
  respond_to do |format|
    format.html { render :slots }
    format.turbo_stream
  end
 end
end
