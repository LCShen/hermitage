require 'spec_helper'
require 'dummy/app/models/dummy'

describe Hermitage::ViewHelpers, type: :helper do

  # Reset Hermitage configs because they should not be shared among specs
  before(:each) { Hermitage.configs = { default: Hermitage::Defaults.to_hash() } }
  
  let(:template) { ActionView::Base.new }

  describe '#render_gallery_for' do
    let(:images) { Array.new(2) { |i| DummyImage.new(i.to_s) } }
    let(:expected) { '<ul class="thumbnails"><li class="span4"><a class="thumbnail" href="/assets/0-full.png" rel="hermitage"><img alt="0 thumbnail" src="/assets/0-thumbnail.png" /></a></li><li class="span4"><a class="thumbnail" href="/assets/1-full.png" rel="hermitage"><img alt="1 thumbnail" src="/assets/1-thumbnail.png" /></a></li></ul>' }
    
    context 'no options' do
      subject { template.render_gallery_for images }
      it { should == expected }
    end

    context 'with options' do
      
      context 'attribute_full_size and attribute_thumbnail' do
        subject { template.render_gallery_for images, attribute_full_size: 'photo', attribute_thumbnail: 'photo(:thumbnail)' }
        let(:images) { Array.new(2) { |i| DummyPhoto.new(i.to_s) } }
        it { should == expected }
      end

      context 'list_tag and item_tag' do
        subject { template.render_gallery_for images, list_tag: :div, item_tag: :div }
        let(:expected) { '<div class="thumbnails"><div class="span4"><a class="thumbnail" href="/assets/0-full.png" rel="hermitage"><img alt="0 thumbnail" src="/assets/0-thumbnail.png" /></a></div><div class="span4"><a class="thumbnail" href="/assets/1-full.png" rel="hermitage"><img alt="1 thumbnail" src="/assets/1-thumbnail.png" /></a></div></div>' }
        it { should == expected }
      end

      context 'list_class, item_class, link_class and image_class' do
        subject { template.render_gallery_for images, list_class: nil, item_class: nil, link_class: 'thumb link', image_class: 'thumb' }
        let(:expected) { '<ul><li><a class="thumb link" href="/assets/0-full.png" rel="hermitage"><img alt="0 thumbnail" class="thumb" src="/assets/0-thumbnail.png" /></a></li><li><a class="thumb link" href="/assets/1-full.png" rel="hermitage"><img alt="1 thumbnail" class="thumb" src="/assets/1-thumbnail.png" /></a></li></ul>' }
        it { should == expected }
      end
    end

    context 'with configs' do

      before(:each) { Hermitage.configs[:dummy_images] = { list_class: 'images-thumbnails' } }

      let(:expected) { '<ul class="images-thumbnails"><li class="span4"><a class="thumbnail" href="/assets/0-full.png" rel="hermitage"><img alt="0 thumbnail" src="/assets/0-thumbnail.png" /></a></li><li class="span4"><a class="thumbnail" href="/assets/1-full.png" rel="hermitage"><img alt="1 thumbnail" src="/assets/1-thumbnail.png" /></a></li></ul>' }
      subject { template.render_gallery_for images }
      it { should == expected }

      context 'with overwritten defaults' do

        before(:each) do
          Hermitage.configs[:default].merge!({
            list_class: 'default-thumbnails',
            item_class: 'span3'
          })
        end

        let(:expected) { '<ul class="images-thumbnails"><li class="span3"><a class="thumbnail" href="/assets/0-full.png" rel="hermitage"><img alt="0 thumbnail" src="/assets/0-thumbnail.png" /></a></li><li class="span3"><a class="thumbnail" href="/assets/1-full.png" rel="hermitage"><img alt="1 thumbnail" src="/assets/1-thumbnail.png" /></a></li></ul>' }
        it { should == expected }

        context 'and with options' do
          subject { template.render_gallery_for images, list_class: 'custom-thumbnails' }
          let(:expected) { '<ul class="custom-thumbnails"><li class="span3"><a class="thumbnail" href="/assets/0-full.png" rel="hermitage"><img alt="0 thumbnail" src="/assets/0-thumbnail.png" /></a></li><li class="span3"><a class="thumbnail" href="/assets/1-full.png" rel="hermitage"><img alt="1 thumbnail" src="/assets/1-thumbnail.png" /></a></li></ul>' }
          it { should == expected }
        end

      end
    end

  end
end