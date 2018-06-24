# TextbundleTo

textbundle format to publishing platforms(steemit)

[Korean] textbundle 포맷의 파일을 글 쓰기 플랫폼(스팀잇)으로 전송

Use below link when install Bear, that is affiliate link.

* [Bear macOS](https://geo.itunes.apple.com/us/app/bear/id1091189122?mt=12&at=1010lcjq&ct=githubtextbundleto)
* [Bear iOS](https://itunes.apple.com/us/app/bear/id1016366447?mt=8&at=1010lcjq&ct=githubtextbundleto)

## Usage

### Docker

```shell
$ docker run -it --rm \
    -v "$(pwd)"/your_text_bundle.textbundle:/app/post.textbundle \
    -e STEEMIT_WIF="your steemit wif" \
    -e STEEMIT_USER_NAME="your steemit user name" \
    -e STEEMIT_TAGS="tag1,tag2" \
    seapy/textbundle_to:1.0.0 steemit
```

### Rake

```shell
$ bundle exec rake steemit:publish"[your_text_bundle.textbundle,your_wif,steemit_user_name,tag1,tag2]"
```

### Ruby

```ruby
config = TextbundleTo::Configuration.new do |config|
  config.steemit_wif_private_key = 'your steemit wif'
  config.steemit_user_name = 'your steemit user name'
end
steemit = TextbundleTo::Steemit::Publish.new(config: config)
result = steemit.publish(textbundle_path: 'your_text_bundle.textbundle', tags: ['tag1','tag2'])
puts result[:success]
puts result[:message]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Docker release

```
$ bin/docker_build 1.0.0
$ bin/docker_release 1.0.0
```

## TODO

* Replace code from node to ruby, when generate image upload key
* Release to rubygems
* Support command line program
* Suppoert medium, wordpress

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/seapy/textbundle_to.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
