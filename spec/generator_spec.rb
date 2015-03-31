require 'spec_helper'

describe FactoryGenerator::Generator do

  describe 'attr_reader' do
    before(:each) do
      @user = User.create(name: 'Gustavo', age: 26)
      @factory = FactoryGenerator::Generator.new(@user, create: false).generate
    end

    it '#attributes' do
      attributes = {
        "id"         => @user.id,
        "name"       => 'Gustavo',
        "age"        => 26,
        "created_at" => DateTime.new(1986,9,29),
        "updated_at" => DateTime.new(1986,9,29)
      }

      expect(@factory.attributes).to eq attributes
    end

    it '#factory_body' do
      text = <<-EOF
    id #{@user.id}
    name 'Gustavo'
    age 26
    created_at '1986-09-29T00:00:00+00:00'
    updated_at '1986-09-29T00:00:00+00:00'
      EOF

      factory_body = @factory.factory_body
      expect(factory_body).to eq text
    end

    it '#options' do
      options = {
        nested: false,
        overwrite: false,
        create: false,
        parent: [],
        skip_attr: [],
        change_attr: {}
      }
      expect(@factory.options).to eq options

    end

    it '#file' do
      expect(@factory.file).to be_a FactoryGenerator::FileManager
    end
  end

  describe 'generator methods' do
    before(:each) do
      @user = User.create(name: 'Gustavo', age: 26)
    end

    it '#manipulates_attributes will change and delete attributes from the object' do
      attributes = {
        'name' => 'Pedro',
        'age'  => 29
      }
      factory_attr = FactoryGenerator::Generator.new(@user,
                  skip_attr: %w(created_at updated_at id),
                  change_attr:{'name' => 'Pedro', 'age' => 29},
                  create: false).manipulate_attributes
      expect(factory_attr).to eq attributes
    end

    describe 'getter object and determine validity of object methods' do

      before(:each) do
        @factory = FactoryGenerator::Generator.new(@user, create: false)
      end

      it '#invalid_object? will return true with nil value' do
        return_value = @factory.invalid_object?(nil)
        expect(return_value).to eq true
      end

      it '#invalid_object? will return true with empty value' do
        return_value = @factory.invalid_object?([])
        expect(return_value).to eq true
      end

      it '#invalid_object? will return false with valid value' do
        return_value = @factory.invalid_object?(@user)
        expect(return_value).to eq false
      end

      it '#get_object will return the object' do
        return_value = @factory.get_object(@user)
        expect(return_value).to eq @user
      end

      it '#get_object will return the object' do
        return_value = @factory.get_object(nil)
        expect(return_value).to eq nil
      end

      it '#get_object will return the object' do
        return_value = @factory.get_object([])
        expect(return_value).to eq nil
      end

      it '#get_object will return the object' do
        user2 = User.new(name: 'Test', age: 30)
        return_value = @factory.get_object([user2, @user])
        expect(return_value).to eq user2
      end

    end
  end
end