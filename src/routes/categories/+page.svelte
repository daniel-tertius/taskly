<script>
  import { Trash } from "$lib/icon";
  import { DB } from "$lib/DB/DB";
  import { onMount } from "svelte";
  import { fly, slide } from "svelte/transition";
  import { sortByField } from "$lib";
  import Plus from "$lib/icon/Plus.svelte";
  import { data } from "../Data.svelte";

  const DEFAULT_NAME = "Verstek";

  let new_category_name = $state("");
  /** @type {string?} */
  let default_id;

  let error_message = $state("");

  onMount(async () => {
    await data.refreshCategories();

    let default_category = data.categories.find(({ name }) => name === DEFAULT_NAME);
    if (!default_category) {
      new_category_name = DEFAULT_NAME;
      await createCategory(new Event("submit"));
      default_category = data.categories.find(({ name }) => name === DEFAULT_NAME);
    }

    default_id = default_category?.id ?? "";
  });

  /**
   * @param {string} id
   */
  async function deleteCategory(id) {
    if (id === default_id) return;

    const Db = DB.getInstance();
    await Db.Category.archive(id);

    const index = data.categories.findIndex((category) => category.id === id);
    if (index !== -1) {
      data.categories.splice(index, 1);
    }
  }

  /**
   * @param {Event} e
   */
  async function createCategory(e) {
    e.preventDefault();

    if (!new_category_name?.trim()) {
      error_message = "Benoem jou kategorie";
      return;
    }

    const Db = DB.getInstance();
    const new_category = await Db.Category.create({ name: new_category_name.trim() });

    data.categories.push(new_category);
    data.categories = sortByField(data.categories, "name");
    new_category_name = "";
  }
</script>

<div class="flex flex-col space-y-2">
  <div>
    <form onsubmit={createCategory} class="flex gap-1 items-center h-12">
      <input
        type="text"
        oninput={() => (error_message = "")}
        bind:value={new_category_name}
        placeholder="Voeg 'n nuwe kategorie by"
        class="w-full h-full rounded-md bg-[#223a51] px-4 py-2 text-sm font-medium text-white transition-colors focus:outline-none focus:ring-2 focus:ring-[#5b758e] focus:ring-offset-2"
      />

      <button
        class="h-full rounded-md bg-[#5b758e] px-4 py-2 font-medium transition-colors hover:bg-[#476480] focus:outline-none focus:ring-2 focus:ring-[#5b758e] focus:ring-offset-2"
      >
        <Plus color="#FFF" />
      </button>
    </form>

    {#if error_message}
      <div class="text-red-600 text-sm mt-1 flex justify-end">
        {error_message}
      </div>
    {/if}
  </div>

  <div class="flex flex-col space-y-2">
    {#each data.categories as category (category.id)}
      <div in:slide out:fly={{ x: 100 }} class="flex items-center justify-between p-2 bg-[#5b758e] rounded-md">
        <div class="text-lg font-semibold text-white">{category.name}</div>

        {#if category.name != DEFAULT_NAME}
          <button class="text-red-500 hover:text-red-700" onclick={() => deleteCategory(category.id)}>
            <Trash />
          </button>
        {/if}
      </div>
    {/each}
  </div>
</div>
