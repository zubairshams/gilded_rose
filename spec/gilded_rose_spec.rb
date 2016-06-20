require_relative '../lib/gilded_rose'

describe "#update_quality" do

  context "with a single item" do
    let(:initial_sell_in) { 5 }
    let(:initial_quality) { 10 }
    let(:name) { "item" }
    let(:item) { Item.new(name, initial_sell_in, initial_quality) }

    before { GlidedRose.update_quality([item]) }

    context 'before sell date' do
      specify 'decreses quality and sell in by 1' do
        expect(item.quality).to eq(initial_quality - 1)
        expect(item.sell_in).to eq(initial_sell_in - 1)
      end
    end

    context 'after sell date' do
      let(:initial_sell_in) { 0 }

      specify 'decreases quality by 2' do
        expect(item.quality).to eq(initial_quality - 2)
      end
    end

    context 'of quality 0' do
      let(:initial_quality) { 0 }

      specify 'should never be negative' do
        expect(item.quality).to be >= 0
      end
    end

    context 'as Aged Brie' do
      let(:name) {'Aged Brie'}

      context 'before sell date' do
        specify 'increases quality by 1' do
          expect(item.quality).to eq(initial_quality + 1)
        end
      end

      context 'after sell date' do
        let(:initial_sell_in) { 0 }

        specify 'increases quality by 2' do
          expect(item.quality).to eq(initial_quality + 2)
        end
      end

      context 'should never have quality more than 50' do
        let(:initial_quality) { 50 }
        let(:initial_sell_in) { 0 }

        specify do
          expect(item.quality).to be <= 50
        end
      end
    end

    context 'as Sulfuras' do
      let(:name) {'Sulfuras, Hand of Ragnaros'}

      specify 'should not change quality and sell in date' do
        expect(item.quality).to eq(initial_quality)
        expect(item.sell_in).to eq(initial_sell_in)
      end
    end

    context 'as Backstage Passes' do
      let(:name) {'Backstage passes to a TAFKAL80ETC concert'}

      context 'with sell in above 10 days' do
        let(:initial_sell_in) { 11 }

        specify 'increases quality by 1' do
          expect(item.quality).to eq(initial_quality + 1)
        end
      end

      context 'with sell in 10 days or below and above 5 days' do
        let(:initial_sell_in) { 10 }

        specify 'increases quality by 2' do
          expect(item.quality).to eq(initial_quality + 2)
        end
      end

      context 'with sell in 5 days or below' do
        let(:initial_sell_in) { 5 }

        specify 'increases quality by 3' do
          expect(item.quality).to eq(initial_quality + 3)
        end
      end

      context 'after sell date' do
        let(:initial_sell_in) { 0 }

        specify 'drops quality to 0' do
          expect(item.quality).to eq(0)
        end
      end
    end

    context 'as Conjured' do
      let(:name) {'Conjured'}

      context 'before sell date' do
        specify 'decreases quality by 2' do
          expect(item.quality).to eq(initial_quality - 2)
        end
      end

      context 'after sell date' do
        let(:initial_sell_in) { 0 }

        specify 'decreases quality by 4' do
          expect(item.quality).to eq(initial_quality - 4)
        end
      end
    end
  end
end
