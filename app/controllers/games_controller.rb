class GamesController < ApplicationController
  def roulette
  end

  def blackjack
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

  # 🔽 TUTAJ AKTUALIZUJEMY SALDO UŻYTKOWNIKA
  if current_user && current_user.wallet
    case max_count
    when 3
      current_user.wallet.increment!(:balance, reward * 3)
    when 2
      current_user.wallet.increment!(:balance, reward)
    else
      current_user.wallet.decrement!(:balance, 10)  # koszt gry
    end
  end
  puts "🎰 Wylosowano symbole: #{@symbols.inspect}"
  puts "👛 Saldo: #{current_user.wallet.balance}" if current_user&.wallet
  respond_to do |format|
    format.html
    format.turbo_stream
  end
 end
end
