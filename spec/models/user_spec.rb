RSpec.describe "User", :type => :model do

  it "can be saved" do
    user = User.create(name: "Mordecai", email: "m@rshow.com")
    user.save!

    found = User.last
    expect(found.name).to eq("Mordecai")
    expect(found.email).to eq("m@rshow.com")
  end

  it "requires a name and an email" do
    user = User.new
    expect(user.valid?).to eq(false)

    user.name = "Rigby"
    expect(user.valid?).to eq(false)

    user.email = "r@rshow.com"
    expect(user.valid?).to eq(true)
  end

  it "requires a somewhat valid email" do
    user = User.new(name: "Rigby")
    expect(user.valid?).to eq(false)

    user.email = "rigby"
    expect(user.valid?).to eq(false)

    user.email = "rigby@rshow"
    expect(user.valid?).to eq(false)

    user.email = "rigby@rshow.com"
    expect(user.valid?).to eq(true)
  end

  it "is impossible to add the same email twice" do
    user = User.create(name: "Mordecai", email: "m@rshow.com")
    expect(user.valid?).to eq(true)

    other_user = User.create(name: "Mordecai", email: "m@rshow.com")
    expect(other_user.valid?).to eq(false)
  end
end