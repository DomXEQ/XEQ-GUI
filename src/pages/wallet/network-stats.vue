<template>
  <q-page class="network-stats-page">
    <div class="header row items-center justify-center q-pt-md q-pb-md">
      <h5 class="q-my-none">{{ $t("titles.networkStats") }}</h5>
    </div>

    <div class="q-pa-md">
      <div class="row q-mb-md items-center">
        <div class="col">
          <q-card>
            <q-card-section>
              <div class="text-h6">Total Service Nodes</div>
              <div class="text-h4 text-primary">{{ totalNodes }}</div>
            </q-card-section>
          </q-card>
        </div>
        <div class="col q-ml-md">
          <q-card>
            <q-card-section>
              <div class="text-h6">Active Service Nodes</div>
              <div class="text-h4 text-positive">{{ activeNodes }}</div>
            </q-card-section>
          </q-card>
        </div>
      </div>

      <q-card>
        <q-card-section>
          <div class="row items-center justify-between q-mb-md">
            <div class="text-h6">{{ $t("strings.allServiceNodes") }}</div>
            <q-btn
              flat
              dense
              round
              icon="refresh"
              :loading="loading"
              @click="refreshNodes"
            >
              <q-tooltip>{{ $t("buttons.refresh") }}</q-tooltip>
            </q-btn>
          </div>

          <q-table
            :data="serviceNodes"
            :columns="columns"
            row-key="service_node_pubkey"
            :loading="loading"
            :pagination.sync="pagination"
            :rows-per-page-options="[10, 25, 50, 100]"
            flat
            dense
          >
            <template v-slot:body-cell-pubkey="props">
              <q-td :props="props">
                <div class="ellipsis" style="max-width: 200px;">
                  {{ props.value }}
                </div>
                <q-tooltip>{{ props.value }}</q-tooltip>
              </q-td>
            </template>

            <template v-slot:body-cell-status="props">
              <q-td :props="props">
                <q-badge
                  :color="props.value === 'ACTIVE' ? 'positive' : 'warning'"
                  :label="props.value"
                />
              </q-td>
            </template>

            <template v-slot:body-cell-registration_height="props">
              <q-td :props="props">
                {{ props.value.toLocaleString() }}
              </q-td>
            </template>

            <template v-slot:body-cell-last_uptime_proof="props">
              <q-td :props="props">
                {{ formatDate(props.value) }}
              </q-td>
            </template>

            <template v-slot:body-cell-total_contributed="props">
              <q-td :props="props">
                <FormatXEQ :amount="props.value" />
              </q-td>
            </template>
          </q-table>
        </q-card-section>
      </q-card>
    </div>
  </q-page>
</template>

<script>
import { mapState } from "vuex";
import FormatXEQ from "components/format_oxen";

export default {
  name: "NetworkStats",
  components: {
    FormatXEQ
  },
  data() {
    return {
      loading: false,
      pagination: {
        rowsPerPage: 25,
        sortBy: "registration_height",
        descending: true
      },
      columns: [
        {
          name: "pubkey",
          label: "Service Node Key",
          field: "service_node_pubkey",
          align: "left",
          sortable: true
        },
        {
          name: "operator_address",
          label: "Operator Address",
          field: "operator_address",
          align: "left",
          sortable: true
        },
        {
          name: "status",
          label: "Status",
          field: row => row.active_state,
          align: "center",
          sortable: true
        },
        {
          name: "total_contributed",
          label: "Staked Amount",
          field: "total_contributed",
          align: "right",
          sortable: true
        },
        {
          name: "registration_height",
          label: "Reg Height",
          field: "registration_height",
          align: "right",
          sortable: true
        },
        {
          name: "last_uptime_proof",
          label: "Last Uptime Proof",
          field: "last_uptime_proof",
          align: "center",
          sortable: true
        },
        {
          name: "public_ip",
          label: "IP Address",
          field: row =>
            row.public_ip
              ? `${row.public_ip}:${row.storage_port || "N/A"}`
              : "N/A",
          align: "left",
          sortable: false
        }
      ]
    };
  },
  computed: {
    ...mapState({
      serviceNodesRaw: state => state.gateway.daemon.service_nodes.nodes || []
    }),
    serviceNodes() {
      return this.serviceNodesRaw.map(node => ({
        ...node,
        active_state: node.active ? "ACTIVE" : "INACTIVE"
      }));
    },
    totalNodes() {
      return this.serviceNodes.length;
    },
    activeNodes() {
      return this.serviceNodes.filter(node => node.active).length;
    }
  },
  mounted() {
    this.refreshNodes();
  },
  methods: {
    refreshNodes() {
      this.loading = true;
      this.$gateway.send("daemon", "update_service_nodes");
      // Wait a moment for the update to complete
      setTimeout(() => {
        this.loading = false;
      }, 1000);
    },
    formatDate(timestamp) {
      if (!timestamp) return "N/A";
      const date = new Date(timestamp * 1000);
      return date.toLocaleString();
    }
  }
};
</script>

<style lang="scss" scoped>
.network-stats-page {
  .header {
    h5 {
      font-weight: 500;
    }
  }
}
</style>
