class @OnboardingDeviceChainsLitecoinViewController extends @OnboardingViewController

  view:
    chainSelected: ".choice"
    remember: "#remember"
    openHelpCenter: "#help"
    link: '#link'

  networks: []

  initialize: ->
    super
    @networks = JSON.parse @params.networks
    l @networks

  onAfterRender: ->
    super
    @view.chainSelected.on "click", @onChainSelected

  onChainSelected: (e) ->
    @chainChoosen(@networks[e.target.attributes.value.value])

  chainChoosen: (e) ->
    ledger.app.dongle.getPublicAddress "44'/#{@networks[0].bip44_coin_type}'/0'/0/0", (addr) =>
      address = ledger.crypto.SHA256.hashString addr.bitcoinAddress.toString(ASCII)
      tmp = {}
      if @view.remember.is(":checked")
        tmp[address]= e
        ledger.storage.global.chainSelector.set tmp, =>
          ledger.storage.global.chainSelector.get address, (result) =>
            ledger.app.onChainChosen(e)
      else
        tmp[address]= 0
        ledger.storage.global.chainSelector.set tmp, =>
          ledger.storage.global.chainSelector.get address, (result) =>
            ledger.app.onChainChosen(e)


  openSupport: ->
    window.open t 'application.support_url'

  onDetach: ->
    super

  openLink: ->
    open("https://bitcoincore.org/en/2016/01/26/segwit-benefits/")
