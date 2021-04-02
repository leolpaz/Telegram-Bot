require_relative '../lib/bot'

describe Bot do
  let (:test) {Bot.new}
  describe '#send_start' do
    it 'returns the text' do
      expect(test.send_start(client, bot)[result][text]).to eql('meme')
    end
  end
end
