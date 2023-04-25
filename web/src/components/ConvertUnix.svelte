<script lang="ts">
  import { visibility } from '../store/stores';
  import { fetchNui } from '../utils/fetchNui';
  import { useNuiEvent } from '../utils/useNuiEvent';
  import moment from 'moment';

  interface Convert {
    unix: number;
    format_date: string;
  };

  const convert = () => {
    useNuiEvent('convertUnix', (data: Convert) => {
      const unixTime: number = moment.duration(data.unix, 'milliseconds').as('seconds');
      const date: any|string = moment.unix(unixTime);
      const formated: string = date.format(data.format_date);
      visibility.set(false);
      fetchNui('returnConvert', formated);
    });
  };

  convert();
</script>
