<template>
  <div class="column wallet-info">
    <div class="row justify-between items-center wallet-header">
      <div class="title">{{ info.name }}</div>
      <WalletSettings />
    </div>
    <div class="wallet-content oxen-navy">
      <div class="row justify-center">
        <div class="funds column items-center">
          <div class="balance">
            <q-btn-toggle
              v-model="balancestakeselector"
              text-color="white"
              toggle-text-color="primary"
              flat
              :options="[
                {
                  label: $t('strings.xeqBalance'),
                  value: 'balance'
                },
                {
                  label: $t('strings.stake'),
                  value: 'stake'
                }
              ]"
            />
            <div class="value row items-center justify-center">
              <span><FormatOxen :amount="info.balance"/></span>
              <q-btn
                flat
                dense
                round
                icon="refresh"
                size="sm"
                color="white"
                class="q-ml-sm"
                :disable="!is_wallet_open"
                @click="rescanWallet"
              >
                <q-tooltip>{{ $t("menuItems.rescanWallet") }}</q-tooltip>
              </q-btn>
            </div>
          </div>
          <div v-if="balancestakeselector != 'stake'" class="row unlocked">
            <span
              >{{ $t("strings.xeqUnlockedShort") }}:
              <FormatOxen :amount="info.unlocked_balance"
            /></span>
          </div>
          <div v-if="balancestakeselector == 'stake'" class="row unlocked">
            <span v-if="info.accrued_balance > 0"
              >{{ $t("strings.xeqAccumulatedRewards") }}:
              <FormatOxen :amount="info.accrued_balance" />•
              {{ $t("strings.nextPayout") }}:
              <FormatNextPayout
                :payout-block="info.accrued_balance_next_payout"
                :current-block="info.height"
              />
            </span>
            <span v-if="info.accrued_balance == 0">
              No accumulated rewards from staking
            </span>
          </div>
        </div>
      </div>
      <div class="wallet-address row justify-center items-center">
        <div class="address">{{ info.address }}</div>
        <CopyIcon :content="info.address" />
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";
import FormatOxen from "components/format_oxen";
import FormatNextPayout from "components/format_next_payout";
import WalletSettings from "components/menus/wallet_settings";
import CopyIcon from "components/icons/copy_icon";
export default {
  name: "WalletDetails",
  components: {
    FormatOxen,
    FormatNextPayout,
    WalletSettings,
    CopyIcon
  },
  computed: mapState({
    theme: state => state.gateway.app.config.appearance.theme,
    info: state => state.gateway.wallet.info,
    is_wallet_open: state =>
      state.gateway.wallet.info && state.gateway.wallet.info.name
  }),
  data() {
    return {
      balancestakeselector: "balance"
    };
  },
  methods: {
    rescanWallet() {
      this.$q
        .dialog({
          title: this.$t("dialog.rescan.title"),
          message: this.$t("dialog.rescan.message"),
          ok: {
            label: this.$t("dialog.rescan.ok"),
            color: "primary"
          },
          cancel: {
            flat: true,
            label: this.$t("buttons.cancel")
          }
        })
        .onOk(() => {
          this.$gateway.send("wallet", "rescan_blockchain");
        })
        .onDismiss(() => {})
        .onCancel(() => {});
    }
  }
};
</script>

<style lang="scss">
.wallet-info {
  .wallet-header {
    padding: 0.8rem 1.5rem;
    .title {
      font-weight: bold;
    }
  }

  .wallet-content {
    text-align: center;
    padding: 2em;

    .balance {
      .text {
        font-size: 16px;
      }
      .value {
        font-size: 35px;

        .q-btn {
          opacity: 0.7;
          transition: opacity 0.2s;

          &:hover {
            opacity: 1;
          }

          &[disabled] {
            opacity: 0.3;
          }
        }
      }
    }

    .wallet-address {
      margin-top: 12px;
      .address {
        overflow: hidden;
        text-overflow: ellipsis;
        margin: 4px 0;
      }
      .q-btn {
        margin-left: 8px;
      }
    }

    .unlocked {
      font-size: 14px;
      font-weight: 500;
    }
  }
}
</style>
